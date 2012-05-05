# postinstall.sh created from Mitchell's official lucid32/64 baseboxes

date > /etc/vagrant_box_build_time

# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev
apt-get -y install libxml2-dev libxslt libcurl4-openssl-dev
apt-get clean

# Setup sudo to allow no-password sudo for "admin"
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install NFS client
apt-get -y install nfs-common

# Install Ruby from source in /opt so that users of Vagrant
# can install their own Rubies using packages or however.
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz
tar xvzf ruby-1.9.2-p180.tar.gz
cd ruby-1.9.2-p180
./configure --prefix=/opt/ruby
make
make install
cd ..
rm -rf ruby-1.9.2-p180*
chmod a+w /opt/ruby

# Install RubyGems 1.3.7
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
tar xzf rubygems-1.3.7.tgz
cd rubygems-1.3.7
/opt/ruby/bin/ruby setup.rb
cd ..
rm -rf rubygems-1.3.7*

# Installing chef & Puppet
/opt/ruby/bin/gem install chef --no-ri --no-rdoc
/opt/ruby/bin/gem install puppet --no-ri --no-rdoc
/opt/ruby/bin/gem install bundler --no-ri --no-rdoc

# Install PostgreSQL 8.3.11
wget http://ftp.postgresql.org/pub/source/v8.3.11/postgresql-8.3.11.tar.gz
tar xzf postgresql-8.3.11.tar.gz
cd postgresql-8.3.11
./configure --prefix=/usr
make
make install
cd ..
rm -rf postgresql-8.3.11*

# Initialize postgres DB
useradd -p postgres postgres
mkdir -p /var/pgsql/data
chown postgres /var/pgsql/data
su -c "/var/pgsql/bin/initdb -D /var/pgsql/data" postgres
mkdir /var/pgsql/data/log
chown postgres /var/pgsql/data/log

# Start postgres
su -c '/var/pgsql/bin/pg_ctl start -l /var/pgsql/data/log/logfile -D /var/pgsql/data' postgres

# Start postgres at boot
sed -i -e 's/exit 0//g' /etc/rc.local
echo "su -c '/var/pgsql/bin/pg_ctl start -l /var/pgsql/data/log/logfile -D /var/pgsql/data' postgres" >> /etc/rc.local

# Add /opt/ruby/bin to the global path as the last resort so
# Ruby, RubyGems, and Chef/Puppet are visible
echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/vagrantruby.sh

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp3/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces
exit
exit
