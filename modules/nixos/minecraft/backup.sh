SERVERNAME="tnauwiecraft"
# Check if /minecraft/[servername] exists
if [ ! -d "/minecraft/${SERVERNAME}" ]; then
  echo "Server directory not found. Exiting..."
  exit 1
fi

NOW=$(date "+%Y-%m-%d_%H%M")
BACKUP_PATH="/servers/minecraft/backups/${SERVERNAME}"
if [ ! -d ${BACKUP_PATH} ]; then
  mkdir -p ${BACKUP_PATH}
fi
ORIGPATH="/srv/minecraft"
BACKUP_FILE="${BACKUP_PATH}/backup_${NOW}.tar.gz"
echo -n "Backing up Minecraft world, including compression"
tar -C ${ORIGPATH} -zcf ${BACKUP_FILE} . --checkpoint=.1000
if [ $? == 0 ]; then
  echo -e "[  OK${NC}  ]"
else
  echo -e "[  FAILED${NC}  ]"
  echo -n "Backup failed. Review tar.log"
fi
echo -en '\nBackup finished at ' && date +'%Y-%m-%d %H%M'
du -h ${BACKUP_FILE}
