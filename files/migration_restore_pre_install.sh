BACKUP_DIR=/vagrant/files/backup

mkdir -p /etc/puppetlabs/puppet
cd /

tar -zxvf $BACKUP_DIR/puppet_ssl.tar.gz
