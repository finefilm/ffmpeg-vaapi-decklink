#!/bin/bash

sudo apt-get update -qq
sudo apt-get upgrade -y
sudo apt-get -y install \
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
  dkms \
  vainfo

# Create directories
mkdir -p $HOME/vaapi
mkdir -p $HOME/vaapi/sources
chown -Rc $USER:$USER $HOME/vaapi

export MY_DISTRO_PREFIX=/usr
export MY_DISTRO_LIBDIR=/usr/lib/x86_64-linux-gnu


# Download recent BMD Decklink SDK
cd $HOME
git clone http://github.com/finefilm/decklink
cd decklink
sudo cp * $MY_DISTRO_PREFIX/include
sudo rm -R $HOME/decklink

# Download and install recent BMD Desktop Video driver and GUI and Media Express
cd $HOME
git clone https://github.com/finefilm/desktopvideo
cd desktopvideo
sudo dpkg -i desktopvideo_*.deb
sudo dpkg -i desktopvideo-gui_*.deb
sudo dpkg -i mediaexpress_*.deb
sudo rm -R $HOME/desktopvideo

# Build and install  C for Media Runtime latest version - https://github.com/intel/cmrt
cd $HOME/vaapi/sources
git clone https://github.com/01org/cmrt
cd cmrt
./autogen.sh
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR
time make -j$(nproc)
sudo make -j$(nproc) install
sudo ldconfig -vvvv

# Build and install VA driver for Intel G45 & HD Graphics family latest version - https://github.com/01org/intel-hybrid-driver
cd $HOME/vaapi/sources
git clone https://github.com/01org/intel-hybrid-driver
cd intel-hybrid-driver
./autogen.sh
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR
time make -j$(nproc)
sudo make -j$(nproc) install
sudo ldconfig -vvv

# Build and install VA-API user mod driver latest version - https://github.com/01org/intel-hybrid-driver
cd $HOME/vaapi/sources
git clone https://github.com/01org/intel-vaapi-driver
cd intel-vaapi-driver
./autogen.sh
./configure --enable-hybrid-codec --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR
time make -j$(nproc)
sudo make -j$(nproc) install
sudo ldconfig -vvvv

# Build and install VA-API latest version - https://github.com/01org/libva
cd $HOME/vaapi/sources
git clone https://github.com/01org/libva
cd libva
./autogen.sh 
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR
time make -j$(nproc)
sudo make -j$(nproc) install

sudo rm -R $HOME/vaapi

sudo systemctl reboot
