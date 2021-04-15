#DATE=2020_03
#TIME=20200331.1600
PWD=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

source ${PWD}/base_conf.sh

DATE=${TIME_YEAR}_${TIME_MONTH}
TIME=${TIME_YEAR}${TIME_MONTH}${TIME_DAY}.${TIME_HOUR}


mkdir -p ${BASE_DIR}/iit-mrt
mkdir -p ${BASE_DIR}/iit-txt
mkdir -p ${BASE_DIR}/iit-parsed/4
mkdir -p ${BASE_DIR}/iit-parsed/6

iit_list=(
    "https://www.isolario.it/Isolario_MRT_data/Alderaan"  "alderaan"
    "https://www.isolario.it/Isolario_MRT_data/Dagobah"   "dagobah"
    "https://www.isolario.it/Isolario_MRT_data/Korriban"  "korriban"
    "https://www.isolario.it/Isolario_MRT_data/Naboo"     "naboo"
    "https://www.isolario.it/Isolario_MRT_data/Taris"     "taris"
)


for n in $(seq 0 2 $(expr "${#iit_list[@]}" - 1));
#for n in $(seq 0 1 1);
do
    uri=${iit_list[$n]}/${DATE}/rib.${TIME}.bz2
    outpath=${BASE_DIR}/iit-mrt/rib.${iit_list[$n+1]}.${TIME}.mrt.bz2
    txtpath=${BASE_DIR}/iit-txt/rib.${iit_list[$n+1]}.${TIME}.txt
    #echo "${uri}"
    echo "${iit_list[$n+1]}"
    #########
    
    wget --no-check-certificate -O $outpath $uri
    bgpdump -m -O ${txtpath} ${outpath}
    RAW_PATH=${txtpath} PARSED_DIR=${BASE_DIR}/iit-parsed ${PY_PATH} dumpfile_parser.py
done
