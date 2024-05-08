sudo apt update 
sudo apt install docker.io
cd /home/jiahui
git clone https://github.com/googleprojectzero/fuzzilli.git
bash /home/jiahui/MasterThesis/prepare.sh
cd /home/jiahui/MasterThesis/Cloud/Docker
sudo bash build.sh spidermonkey 

cd /home/jiahui/MasterThesis
tmux new "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=spidermonkey --timeout=1000 --storagePath=./spidermonkey --jobs=4 --minimizationLimit=0.2 ~/MasterThesis/Cloud/Docker/SpidermonkeyBuilder/out/js > SpidermonkeyJIT.log"

cd /home/jiahui/fuzzilli
tmux new "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=spidermonkey --timeout=1000 --storagePath=./spidermonkey --jobs=4  ~/MasterThesis/Cloud/Docker/SpidermonkeyBuilder/out/js > Spidermonkey.log"