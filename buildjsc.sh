sudo apt update 
sudo apt install docker.io
cd /home/jiahui
git clone https://github.com/googleprojectzero/fuzzilli.git
bash /home/jiahui/MasterThesis/prepare.sh
cd /home/jiahui/MasterThesis
bash Cloud/Docker/build.sh jsc
tmux new "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4 --minimizationLimit=0.2 ~/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc > JSCJIT.log"

cd /home/jiahui/fuzzilli
tmux new "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4  ~/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc > JSC.log"