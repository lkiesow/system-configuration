#!/bin/sh

# Select package manager (prefer dnf)
dnf --version &> /dev/null && PM='dnf' || PM='yum'

# Make some choices
read -r -p "Install laptop related stuff? [y/N]: " installlaptop
read -r -p "Install desktop/laptop related stuff? [y/N]: " installdesktop
read -r -p "Install Adobe Flash player? [y/N]: " installflash
read -r -p "Install some additional python libs? [y/N]: " installpython
read -r -p "Install RPM development tools? [y/N]: " installrpmdevtools
read -r -p "Install development tools? [y/N]: " installdevtools
grep Fedora /etc/redhat-release &> /dev/null && \
	read -r -p "Install fake texlive package? [y/N]: " installtexlivefake

# Remove unwanted packages
sudo ${PM} remove clipit

# Always install these packages
sudo ${PM} install aspell aspell-de aspell-en cmake ctags fuse-sshfs gnupg \
	hunspell hunspell-de hunspell-en hunspell-en-GB hunspell-en-US ImageMagick \
	man-pages mc nload perl-JSON-XS pulseaudio-utils tmux tsocks v4l-utils \
	vim-enhanced vim-x11 wget zsh htop

# On Fedora, install RPMFusion
grep Fedora /etc/redhat-release &> /dev/null && sudo yum localinstall --nogpgcheck \
	http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# ... and Adobe Flash
[[ "${installflash}n" =~ ^y ]] && grep Fedora /etc/redhat-release &>/dev/null \
	&& sudo yum localinstall \
	http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm

sudo ${PM} clean all
# For laptops
[[ "${installlaptop}n" =~ ^y ]] && sudo ${PM} install acpi xbacklight

# Install texlive-fake
if [[ "${installtexlivefake}n" =~ ^y ]]
then
	git clone https://github.com/lkiesow/texlive-fake.git /tmp/texlive-fake
	sudo yum localinstall /tmp/texlive-fake/texlive-fake-*.fc$(rpm -E %fedora).noarch.rpm
	rm -rf /tmp/texlive-fake
fi

# For desktops and laptops
[[ "${installdesktop}n" =~ ^y ]] && sudo ${PM} install cclive claws-mail \
	claws-mail-plugins cups-pdf darktable docker-io easytag eog evince firefox \
	gimp gitk gparted impressive inkscape keepassx libreoffice mariadb \
	mariadb-server maven mediainfo mkvtoolnix-gui mpv mumble ncftp pandoc \
	pavucontrol pulseaudio-utils redis sane-backends \
	sane-backends-drivers-scanners sane-backends-libs scantailor simple-scan \
	tesseract tesseract-langpack-deu tesseract-langpack-deu tsocks unrar \
	v4l-utils vlc vlc-core vlc-extras w3m weechat xcalib xnoise

# Install Flash
[[ "${installflash}n" =~ ^y ]] && grep Fedora /etc/redhat-release &>/dev/null \
	&& sudo ${PM} install flash-plugin

# Install some Python stuff
[[ "${installpython}n" =~ ^y ]] && sudo ${PM} install python3 \
	python3-dateutil python3-lxml python3-pycurl python-daemon python-dateutil \
	python-flask python-gunicorn python-icalendar python-ipython \
	python-markdown2 python-markdown python-memcached python-nltk \
	python-pycurl python-pylibmc python-redis python-sqlalchemy \
	python-virtualenv

# Install some development tools
[[ "${installdevtools}n" =~ ^y ]] && sudo ${PM} groupinstall 'Development Tools'

# Install RPM development tools
[[ "${installrpmdevtools}n" =~ ^y ]] && sudo ${PM} install createrepo \
	rpmdevtools rpmlint
