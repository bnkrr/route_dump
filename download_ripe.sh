PWD=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${PWD}/base_conf.sh

DATE=${TIME_YEAR}.${TIME_MONTH}
TIME=${TIME_YEAR}${TIME_MONTH}${TIME_DAY}.${TIME_HOUR}

mkdir -p ${BASE_DIR}/mrt
mkdir -p ${BASE_DIR}/txt
mkdir -p ${BASE_DIR}/parsed/4
mkdir -p ${BASE_DIR}/parsed/6

rr=( 0 1 3 4 5 6 7 10 11 12 13 14 15 16 18 19 20 21 22 23 24 )
#rr+=( $(seq 18 24 ) )
#rr=( 24 )
for i in "${rr[@]}"
do
    p=$(printf "%02d" ${i})
    uri=http://data.ris.ripe.net/rrc${p}/${DATE}/bview.${TIME}.gz
    outpath=${BASE_DIR}/mrt/rrc${p}.${TIME}.mrt.gz
    txtpath=${BASE_DIR}/txt/rrc${p}.${TIME}.txt
    #echo $uri
    echo $outpath
    wget -O $outpath $uri
    bgpdump -m -O ${txtpath} ${outpath}
    RAW_PATH=${txtpath} PARSED_DIR=${BASE_DIR}/parsed ${PY_PATH} dumpfile_parser.py
done
