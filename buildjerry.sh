cd /home/jiahui
git clone https://github.com/googleprojectzero/fuzzilli.git
git clone https://github.com/zhangjiahui-buaa/MasterThesis.git
bash /home/jiahui/MasterThesis/prepare.sh
cd /home/jiahui
git clone https://github.com/jerryscript-project/jerryscript
cd jerryscript
git checkout 8ba0d1b6ee5a065a42f3b306771ad8e3c0d819bc
git apply /home/jiahui/MasterThesis/Targets/Jerryscript/Patches/jerryscript.patch
bash /home/jiahui/MasterThesis/Targets/Jerryscript/fuzzbuild.sh

cd /home/jiahui/MasterThesis
tmux new "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=jerryscript --timeout=1000 --storagePath=./jerryscript --jobs=4 --minimizationLimit=0.2 ~/jerryscript/build/bin/jerry > jerryJIT.log"

cd /home/jiahui/fuzzilli
tmux new "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=jerryscript --timeout=1000 --storagePath=./jerryscript --jobs=4 ~/jerryscript/build/bin/jerry > jerryJIT.log"