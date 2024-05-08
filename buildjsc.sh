USER=$1
sudo apt update 
sudo apt install docker.io
cd /home/$USER
git clone https://github.com/googleprojectzero/fuzzilli.git
bash /home/$USER/MasterThesis/prepare.sh $USER
cd /home/$USER/MasterThesis/Cloud/Docker
sudo bash build.sh jsc

cd /home/$USER/MasterThesis
tmux new -d "taskset -c 0,1,2,3 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4 --minimizationLimit=0.2 --exportStatistics --statisticsExportInterval=5 /home/$USER/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc"

cd /home/$USER/fuzzilli
tmux new -d "taskset -c 4,5,6,7 swift run -c release FuzzilliCli --profile=jsc --timeout=1000 --storagePath=./jsc --jobs=4 --exportStatistics --statisticsExportInterval=5 home/$USER/MasterThesis/Cloud/Docker/JSCBuilder/out/jsc"