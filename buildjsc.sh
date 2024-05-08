sudo apt update 
sudo apt install docker.io
cd ~
git clone https://github.com/googleprojectzero/fuzzilli.git
bash ~/MasterThesis/prepare.sh
cd ~/MasterThesis
bash Cloud/Docker/build.sh jsc
tmux new "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4 --minimizationLimit=0.2 ~/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc > JSCJIT.log"

cd ~/fuzzilli
tmux new "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4  ~/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc > JSC.log"