cd /home/jiahui
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=/home/jiahui/depot_tools:$PATH
git clone https://github.com/googleprojectzero/fuzzilli.git
gclient
mkdir /home/jiahui/v8
cd /home/jiahui/v8
fetch v8
cd v8
gclient sync
./build/install-build-deps.sh
bash /home/jiahui/MasterThesis/Targets/V8/fuzzbuild.sh
bash /home/jiahui/MasterThesis/prepare.sh

cd /home/jiahui/MasterThesis
tmux new "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=v8 --timeout=1000 --storagePath=./v8 --jobs=4 --minimizationLimit=0.2 ~/v8/v8/out/fuzzbuild/d8 > v8JIT.log"

cd /home/jiahui/fuzzilli
tmux new "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=v8 --timeout=1000 --storagePath=./v8 --jobs=4 ~/v8/v8/out/fuzzbuild/d8 > v8.log"