Install:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run nix-darwin -- switch --flake github:koen-benne/chad-nix
```


Todo:
- move modules to modules folder
- give each system a subfolder in hosts, maybe rename to systems
- add secret management?
- rename flakes folder to imports or parts or something. They are literally just modules, so this name is confusing
