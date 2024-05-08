sudo apt update 
sudo apt install docker.io
cd ~
git clone https://github.com/zhangjiahui-buaa/MasterThesis.git
bash ~/MasterThesis/prepare.sh
cd ~/MasterThesis
bash Cloud/Docker/build.sh spidermonkey 
tmux new "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=spidermonkey --timeout=1000 --storagePath=./spidermonkey --jobs=4 --minimizationLimit=0.2 ~/MasterThesis/Cloud/Docker/SpidermonkeyBuilder/out/js > SpidermonkeyJIT.log"

cd ~/fuzzilli
tmux new "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=spidermonkey --timeout=1000 --storagePath=./spidermonkey --jobs=4  ~/MasterThesis/Cloud/Docker/SpidermonkeyBuilder/out/js > Spidermonkey.log"