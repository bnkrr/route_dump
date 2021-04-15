PWD=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

#### install dependencies
# sudo apt install -y bgpdump wget


bash ${PWD}/download_iit.sh
bash ${PWD}/download_oix.sh
bash ${PWD}/download_ripe.sh
