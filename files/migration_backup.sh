BACKUP_DIR=/vagrant/files/backup

tar -zcvf $BACKUP_DIR/puppet_ssl.tar.gz /etc/puppetlabs/puppet/ssl/

sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-puppetdb -f /tmp/pe-puppetdb.backup.bin
sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-classifier -f /tmp/pe-classifier.backup.bin
sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-rbac -f /tmp/pe-rbac.backup.bin
sudo -u pe-postgres /opt/puppet/bin/pg_dump -Fc pe-activity -f /tmp/pe-activity.backup.bin

mv /tmp/*.backup.bin $BACKUP_DIR/
