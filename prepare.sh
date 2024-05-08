USER=$1
cd /home/$USER
sudo apt update
sudo apt-get install \
          binutils \
          git \
          gnupg2 \
          libc6-dev \
          libcurl4-openssl-dev \
          libedit2 \
          libgcc-9-dev \
          libpython3.8 \
          libsqlite3-0 \
          libstdc++-9-dev \
          libxml2-dev \
          libz3-dev \
          pkg-config \
          tzdata \
          unzip \
          zlib1g-dev
wget https://download.swift.org/swift-5.9.2-release/ubuntu2204/swift-5.9.2-RELEASE/swift-5.9.2-RELEASE-ubuntu22.04.tar.gz
tar zxvf ./swift-5.9.2-RELEASE-ubuntu22.04.tar.gz
export PATH=/home/$USER/swift-5.9.2-RELEASE-ubuntu22.04/usr/bin:${PATH}
echo 'export PATH=/home/$USER/swift-5.9.2-RELEASE-ubuntu22.04/usr/bin:${PATH}' >> /home/$USER/.bashrc
