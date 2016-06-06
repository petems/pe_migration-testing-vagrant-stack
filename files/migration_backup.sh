BACKUP_DIR=/vagrant/files/backup

tar -zcvf $BACKUP_DIR/puppet_ssl.tar.gz /etc/puppetlabs/puppet/ssl/

sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-puppetdb -f $BACKUP_DIR/pe-puppetdb.backup.bin
sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-classifier -f $BACKUP_DIR/pe-classifier.backup.bin
sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-rbac -f $BACKUP_DIR/pe-rbac.backup.bin
sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-activity -f $BACKUP_DIR/pe-activity.backup.bin
