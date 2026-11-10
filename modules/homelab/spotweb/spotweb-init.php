<?php

declare(strict_types=1);

function requiredEnvironment(string $name): string
{
    $value = getenv($name);

    if ($value === false || $value === '') {
        throw new RuntimeException(
            "Missing required environment variable: {$name}"
        );
    }

    return $value;
}

function readCredential(string $name): string
{
    $credentialsDirectory = requiredEnvironment('CREDENTIALS_DIRECTORY');
    $path = $credentialsDirectory . '/' . $name;

    if (!is_readable($path)) {
        throw new RuntimeException(
            "Unable to read systemd credential: {$name}"
        );
    }

    $value = trim(file_get_contents($path));

    if ($value === '') {
        throw new RuntimeException(
            "Systemd credential is empty: {$name}"
        );
    }

    return $value;
}

function readNntpConfiguration(): array
{
    try {
        $config = json_decode(
            readCredential('nntp-config'),
            true,
            512,
            JSON_THROW_ON_ERROR
        );
    } catch (JsonException $exception) {
        throw new RuntimeException(
            'Unable to parse nntp-config as JSON: ' . $exception->getMessage(),
            0,
            $exception
        );
    }

    foreach (['host', 'username', 'password'] as $key) {
        if (!isset($config[$key]) || $config[$key] === '') {
            throw new RuntimeException(
                "Missing NNTP configuration value: {$key}"
            );
        }
    }

    return [
        'host' => $config['host'],
        'user' => $config['username'],
        'pass' => $config['password'],
        'port' => (int) ($config['port'] ?? 563),
        'enc' => ($config['tls'] ?? true) ? 'ssl' : false,
        'buggy' => false,
        'verifyname' => $config['verifyCertificateName'] ?? true,
    ];
}

try {
    $appDir = requiredEnvironment('SPOTWEB_APP_DIR');

    require_once $appDir . '/vendor/autoload.php';

    /*
     * The systemd unit must run Spotweb's upstream upgrade-db.php first.
     * At this point the schema, default settings, built-in users, groups,
     * permissions and filters must already exist.
     */
    $bootstrap = new Bootstrap();
    [$settings, $daoFactory] = $bootstrap->boot();

    $dbSettings = $bootstrap->getDbSettings();

    $upgrader = new Services_Upgrade_Base(
        $daoFactory,
        $settings,
        $dbSettings['engine']
    );

    $userService = new Services_User_Record($daoFactory, $settings);
    $userDao = $daoFactory->getUserDao();

    $adminUsername = requiredEnvironment('SPOTWEB_ADMIN_USERNAME');
    $adminUserId = $userDao->findUserIdForName($adminUsername);
    $adminPassword = readCredential('admin-password');

    /*
     * Create the user derived from config.my.user on a new installation.
     * The username must not be one of Spotweb's reserved names, such as
     * "admin", "root", or "spotweb".
     */
    if (empty($adminUserId)) {
        $adminUser = [
            'username' => $adminUsername,
            'firstname' => requiredEnvironment('SPOTWEB_ADMIN_FIRST_NAME'),
            'lastname' => requiredEnvironment('SPOTWEB_ADMIN_LAST_NAME'),
            'mail' => requiredEnvironment('SPOTWEB_ADMIN_EMAIL'),
            'newpassword1' => $adminPassword,
            'newpassword2' => $adminPassword,
        ];

        $result = $userService->createUserRecord($adminUser);

        if (!$result->isSuccess()) {
            throw new RuntimeException(
                'Unable to create Spotweb administrator: '
                . implode('; ', $result->getErrors())
            );
        }

        $adminUserId = $result->getData('userid');
    }

    /*
     * Give the configured administrator the supplied password.
     *
     * The built-in administrator, ID 2, is used by Spotweb's CLI retriever,
     * so keep its password in sync as well. This script is run once only:
     * the NixOS systemd unit creates its marker after success.
     */
    $configuredAdmin = $userService->getUser((int) $adminUserId);

    if ($configuredAdmin === false) {
        throw new RuntimeException(
            "Unable to retrieve configured Spotweb administrator: {$adminUsername}"
        );
    }

    $configuredAdmin['newpassword1'] = $adminPassword;
    $configuredAdmin['newpassword2'] = $adminPassword;
    $userService->setUserPassword($configuredAdmin);

    $builtInAdmin = $userService->getUser(SPOTWEB_ADMIN_USERID);

    if ($builtInAdmin === false) {
        throw new RuntimeException(
            'Unable to retrieve Spotweb built-in administrator'
        );
    }

    $builtInAdmin['newpassword1'] = $adminPassword;
    $builtInAdmin['newpassword2'] = $adminPassword;
    $userService->setUserPassword($builtInAdmin);

    /*
     * This is an internal, personal Spotweb deployment rather than a public
     * multi-user instance.
     */
    $settings->set('custom_admin_userid', (int) $adminUserId);
    $upgrader->resetSystemType('single');

    /*
     * Spotweb stores these separately even when all three point at the same
     * NNTP provider. It uses the provider to retrieve Spotnet metadata and,
     * as necessary, NZB information.
     */
    $nntp = readNntpConfiguration();

    $settings->set('nntp_hdr', $nntp);
    $settings->set('nntp_nzb', $nntp);
    $settings->set('nntp_post', $nntp);

    echo "Spotweb application configuration completed.\n";
} catch (Throwable $exception) {
    fwrite(STDERR, $exception->getMessage() . PHP_EOL);
    fwrite(STDERR, $exception->getTraceAsString() . PHP_EOL);
    exit(1);
}
