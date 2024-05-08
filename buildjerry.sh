bash ~/prepare.sh
cd ~
git clone https://github.com/jerryscript-project/jerryscript
cd jerryscript
git checkout 8ba0d1b6ee5a065a42f3b306771ad8e3c0d819bc
git apply ~/MasterThesis/Targets/Jerryscript/Patches/jerryscript.patch
bash ~/MasterThesis/Targets/Jerryscript/fuzzbuild.sh

cd ~/MasterThesis
tmux new "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=jerryscript --timeout=1000 --storagePath=./jerryscript --jobs=4 --minimizationLimit=0.2 ~/jerryscript/build/bin/jerry > jerryJIT.log"

cd ~/fuzzilli
tmux new "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=jerryscript --timeout=1000 --storagePath=./jerryscript --jobs=4 ~/jerryscript/build/bin/jerry > jerryJIT.log"