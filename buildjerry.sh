USER=$1
cd /home/$USER
git clone https://github.com/googleprojectzero/fuzzilli.git
git clone https://github.com/zhang$USER-buaa/MasterThesis.git
bash /home/$USER/MasterThesis/prepare.sh
cd /home/$USER
git clone https://github.com/jerryscript-project/jerryscript
cd jerryscript
git checkout 8ba0d1b6ee5a065a42f3b306771ad8e3c0d819bc
git apply /home/$USER/MasterThesis/Targets/Jerryscript/Patches/jerryscript.patch
bash /home/$USER/MasterThesis/Targets/Jerryscript/fuzzbuild.sh

cd /home/$USER/MasterThesis
tmux new -d "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=jerryscript --timeout=1000 --storagePath=./jerryscript --jobs=4 --minimizationLimit=0.2 --exportStatistics --statisticsExportInterval=5 /home/$USER/jerryscript/build/bin/jerry"

cd /home/$USER/fuzzilli
tmux new -d "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=jerryscript --timeout=1000 --storagePath=./jerryscript --jobs=4  --exportStatistics --statisticsExportInterval=5 /home/$USER/jerryscript/build/bin/jerry"