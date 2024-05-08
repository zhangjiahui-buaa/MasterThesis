USER=$1
cd /home/$USER
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=/home/$USER/depot_tools:$PATH
git clone https://github.com/googleprojectzero/fuzzilli.git
gclient
mkdir /home/$USER/v8
cd /home/$USER/v8
fetch v8
cd v8
gclient sync
./build/install-build-deps.sh
bash /home/$USER/MasterThesis/Targets/V8/fuzzbuild.sh
bash /home/$USER/MasterThesis/prepare.sh

cd /home/$USER/MasterThesis
tmux new -d "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=v8 --timeout=1000 --storagePath=./v8 --jobs=4 --minimizationLimit=0.2 --exportStatistics --statisticsExportInterval=5 /home/$USER/v8/v8/out/fuzzbuild/d8"

cd /home/$USER/fuzzilli
tmux new -d "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=v8 --timeout=1000 --storagePath=./v8 --jobs=4 --exportStatistics --statisticsExportInterval=5 /home/$USER/v8/v8/out/fuzzbuild/d8"