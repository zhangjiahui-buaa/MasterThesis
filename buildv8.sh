cd ~
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=~/depot_tools:$PATH
gclient
mkdir ~/v8
cd ~/v8
fetch v8
cd v8
gclient sync
./build/install-build-deps.sh
