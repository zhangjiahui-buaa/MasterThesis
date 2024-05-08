sudo apt update 
sudo apt install docker.io
cd /home/jiahui
git clone https://github.com/googleprojectzero/fuzzilli.git
bash /home/jiahui/MasterThesis/prepare.sh
cd /home/jiahui/MasterThesis/Cloud/Docker
sudo bash build.sh jsc

cd /home/jiahui/MasterThesis
tmux new -d "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4 --minimizationLimit=0.2 --exportStatistics --statisticsExportInterval=5 /home/jiahui/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc"

cd /home/jiahui/fuzzilli
tmux new -d "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4 --exportStatistics --statisticsExportInterval=5 home/jiahui/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc"