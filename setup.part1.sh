#!/bin/bash
echo "This script is only tested on Ubuntu 16.04.3 LTS"
echo "Updating APT"
sudo apt-get -y -qq update > /dev/null
echo "Upgrading system"
sudo apt-get -y -qq upgrade > /dev/null
echo "Installing dependencies and useful stuff"
sudo apt-get -y -qq install \
  autoconf \
  automake \
  build-essential \
  cmake \
  cmake-curses-gui \
  git \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtheora-dev \
  libtool \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  gcc-arm-linux-gnueabi \
  g++-arm-linux-gnueabi \
  mercurial \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  ssh \
  tcl \
  dkms > /dev/null

# Create directories
echo "Creating folder for source files"
mkdir -p /tmp/vaapi
mkdir -p /tmp/vaapi/sources
chown -Rc $USER:$USER /tmp/vaapi

# Exporting environmental variables
echo "Setting environmental variables"
export MY_DISTRO_PREFIX=/usr
export MY_DISTRO_LIBDIR=/usr/lib/x86_64-linux-gnu
export PATH="$MY_DISTRO_PREFIX:$PATH"

# Download recent BMD Decklink SDK
echo "Downloading Blackmagic Design - Decklink SDK"
cd /tmp
git clone http://github.com/finefilm/decklink > /dev/null
cd decklink
sudo cp * $MY_DISTRO_PREFIX/include

# Download and install recent BMD Desktop Video driver and GUI and Media Express
cd /tmp
echo "Downloading Blackmagic Design - Desktop Video bundle"
git clone http://github.com/finefilm/desktopvideo > /dev/null
cd desktopvideo
echo "Installing Blackmagic Design - Desktop Video driver"
sudo dpkg -i desktopvideo_*.deb > /dev/null
echo "Installing Blackmagic Design - Desktop Video GUI"
sudo dpkg -i desktopvideo-gui_*.deb > /dev/null
echo "Installing Blackmagic Design - Media Express"
sudo dpkg -i mediaexpress_*.deb > /dev/null

# Build and install VA-API latest version - https://github.com/intel/libva
cd /tmp/vaapi/sources
echo "Downloading VA-API latest version"
git clone http://github.com/intel/libva > /dev/null
cd libva
echo "Configuring VA-API"
./autogen.sh --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --bindir="$MY_DISTRO_PREFIX/bin" > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --bindir="$MY_DISTRO_PREFIX/bin" > /dev/null
echo "Buliding VA-API"
make -j$(nproc) > /dev/null
echo "Installing VA-API"
sudo make -j$(nproc) install > /dev/null

# Build and install LibVA-utils latest version - https://github.com/intel/libva-utils
cd /tmp/vaapi/sources
echo "Downloading LibVA-utils latest version"
git clone http://github.com/intel/libva-utils > /dev/null
cd libva-utils
echo "Configuring LibVA-utils"
./autogen.sh --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --bindir="$MY_DISTRO_PREFIX/bin" > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --bindir="$MY_DISTRO_PREFIX/bin" > /dev/null
echo "Buliding LibVA-utils"
make -j$(nproc) > /dev/null
echo "Installing LibVA-utils"
sudo make -j$(nproc) install > /dev/null


# Build and install  C for Media Runtime latest version - https://github.com/intel/cmrt
cd /tmp/vaapi/sources
echo "Downloading CMRT - C for Media Runtime latest version"
git clone http://github.com/01org/cmrt > /dev/null
cd cmrt
echo "Configuring CMRT"
./autogen.sh --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR > /dev/null
echo "Buliding CMRT"
make -j$(nproc) > /dev/null
echo "Installing CMRT"
sudo make -j$(nproc) install > /dev/null
sudo ldconfig > /dev/null

# Build and install VA driver for Intel G45 & HD Graphics family latest version - https://github.com/01org/intel-hybrid-driver
cd /tmp/vaapi/sources
echo "Downloading VA driver for Intel G45 & HD Graphics family latest version"
git clone https://github.com/01org/intel-hybrid-driver > /dev/null
cd intel-hybrid-driver
echo "Configuring VA driver"
./autogen.sh --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR > /dev/null
echo "Buliding VA driver"
make -j$(nproc) > /dev/null
echo "Installing VA driver"
sudo make -j$(nproc) install > /dev/null
sudo ldconfig

# Build and install VA-API user mod driver latest version - hhttp://github.com/intel/intel-vaapi-driver
cd /tmp/vaapi/sources
echo "Downloading VA-API user mod driver latest version"
git clone http://github.com/intel/intel-vaapi-driver > /dev/null
cd intel-vaapi-driver
echo "Configuring VA-API user mod driver"
./autogen.sh --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR > /dev/null
./configure --enable-hybrid-codec --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR > /dev/null
echo "Buliding VA-API user mod driver"
make -j$(nproc) > /dev/null
echo "Installing VA-API user mod driver"
sudo make -j$(nproc) install > /dev/null > /dev/null
sudo ldconfig

echo "Reboting system"
# Wait 5 seconds
sleep 5

# Reboot system
sudo systemctl reboot
