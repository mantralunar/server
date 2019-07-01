# fetch kodi + patch 

wget https://raw.githubusercontent.com/linuxserver/docker-kodi-headless-armhf/master/patches/Leia/headless.patch
wget "https://github.com/xbmc/xbmc/archive/18.2-Leia.tar.gz"

# install build packages

apt-get update
apt-get install \
  ant \
  git-core \
  build-essential \
  autoconf \
  automake \
  cmake \
  pkg-config \
  autopoint \
  libtool \
  swig \
  doxygen \
  default-jdk-headless \
  libbz2-dev \
  liblzo2-dev \
  libtinyxml-dev \
  libmariadbclient-dev-compat \
  libcurl4-openssl-dev \
  libssl-dev \
  libyajl-dev \
  libxml2-dev \
  libxslt-dev \
  libsqlite3-dev \
  libnfs-dev \
  libpcre3-dev \
  libtag1-dev \
  libsmbclient-dev \
  libmicrohttpd-dev \
  libgnutls28-dev \
  libass-dev \
  libxrandr-dev \
  libegl1-mesa-dev \
  libgif-dev \
  libjpeg-dev \
  libglu1-mesa-dev \
  gawk \
  gperf \
  curl \
  m4 \
  python-dev \
  uuid-dev \
  yasm \
  unzip \
  libiso9660-dev \
  libfstrcmp-dev \
  zip

	
# fetch source and apply patch

rm -R /tmp/kodi_src/
mkdir -p /tmp/kodi_src/
tar xf /root/18.2-Leia.tar.gz -C /tmp/kodi_src --strip-components=1
cd /tmp/kodi_src
git apply /root/headless.patch

# build package

mkdir /tmp/kodi_src/build
cd /tmp/kodi_src/build
  cmake ../ \
  -DCMAKE_C_FLAGS="-march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -mvectorize-with-neon-quad" \
  -DCMAKE_CXX_FLAGS="-march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -mvectorize-with-neon-quad" \
  -DCMAKE_INSTALL_LIBDIR=/usr/lib \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DENABLE_INTERNAL_FLATBUFFERS=ON \
  -DENABLE_INTERNAL_FMT=ON \
  -DENABLE_INTERNAL_RapidJSON=ON \
  -DENABLE_SMBCLIENT=OFF \
  -DENABLE_MYSQLCLIENT=ON \
  -DENABLE_NFS=ON \
  -DENABLE_UPNP=OFF \
  -DENABLE_LCMS2=OFF \
  -DENABLE_AIRTUNES=OFF \
  -DENABLE_CAP=OFF \
  -DENABLE_DVDCSS=OFF \
  -DENABLE_LIBUSB=OFF \
  -DENABLE_EVENTCLIENTS=OFF \
  -DENABLE_OPTICAL=OFF \
  -DENABLE_CEC=OFF \
  -DENABLE_BLURAY=OFF \
  -DENABLE_BLUETOOTH=OFF \
  -DENABLE_PULSEAUDIO=OFF \
  -DENABLE_AVAHI=OFF \
  -DENABLE_ALSA=OFF \
  -DENABLE_DBUS=OFF \
  -DENABLE_UDEV=OFF \
  -DENABLE_VAAPI=OFF \
  -DENABLE_VDPAU=OFF \
  -DENABLE_GLX=OFF \
  -DENABLE_SNDIO=OFF
make -j$(nproc --all)
make DESTDIR=/tmp/kodi_build install


cp /tmp/kodi_src/tools/EventClients/Clients/KodiSend/kodi-send.py /tmp/kodi_build/usr/bin/kodi-send
mkdir -p /tmp/kodi_build/usr/lib/python2.7/
cp /tmp/kodi_src/tools/EventClients/lib/python/xbmcclient.py /tmp/kodi_build/usr/lib/python2.7/xbmcclient.py

cp /tmp/kodi_build/usr/* /usr/

# install runtime packages
apt-get update && \
apt-get install -y \
	--no-install-recommends \
  libcurl3 \
  libegl1-mesa \
  libglu1-mesa \
  libfreetype6 \
  libfribidi0 \
  libglew2.0 \
  liblzo2-2 \
  libmicrohttpd12 \
  libmariadbclient18 \
  libnfs8 \
  libpcrecpp0v5 \
  libpython2.7 \
  libsmbclient \
  libtag1v5 \
  libtinyxml2.6.2v5 \
  libxml2 \
  libcdio13 \
  libxcb-shape0 \
  libxrandr2 \
  libxslt1.1 \
  libyajl2 \
  libass5 \
  libiso9660-8 \
  libfstrcmp0 \
  ca-certificates

# Download advancedsettings.xml template
wget -O /usr/share/kodi/portable_data/userdata/advancedsettings.xml https://raw.githubusercontent.com/milaq/kodi-headless/leia/advancedsettings.xml.default

# Edit advancedsettings.xml template
nano /usr/share/kodi/portable_data/userdata/advancedsettings.xml

# Start Kodi instance
kodi -p --standalone --headless

# View Kodi Launch Logs
tail -F -q /usr/share/kodi/portable_data/temp/kodi.log

# Kill Kodi Instance
ps
kill -9 kodi 

# cleanup 
rm -R /tmp/kodi_src 
rm -R /tmp/kodi_build
apt-get clean

# Update Library
kodi-send --action='UpdateLibrary(video)' > /dev/null

	
