PWD=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${PWD}/base_conf.sh

DATE=${TIME_YEAR}.${TIME_MONTH}
TIME=${TIME_YEAR}${TIME_MONTH}${TIME_DAY}.${TIME_HOUR}


mkdir -p ${BASE_DIR}/oix-mrt
mkdir -p ${BASE_DIR}/oix-txt
mkdir -p ${BASE_DIR}/oix-parsed/4
mkdir -p ${BASE_DIR}/oix-parsed/6

oix_list=(
    "http://routeviews.org/bgpdata"                         "rv2"
    "http://routeviews.org/route-views3/bgpdata"            "rv3"
    "http://routeviews.org/route-views4/bgpdata"            "rv4"
    "http://routeviews.org/route-views.amsix/bgpdata"       "amsix"
    "http://routeviews.org/route-views.chicago/bgpdata"     "chicago"
    "http://routeviews.org/route-views.chile/bgpdata"       "chile"
    "http://routeviews.org/route-views.eqix/bgpdata"        "eqix"
    "http://routeviews.org/route-views6/bgpdata"            "rv6"
    "http://routeviews.org/route-views.flix/bgpdata"        "flix"
#    "http://routeviews.org/route-views.gorex/bgpdata"       "gorex"
    "http://routeviews.org/route-views.isc/bgpdata"         "isc"
    "http://routeviews.org/route-views.kixp/bgpdata"        "kixp"
#    "http://routeviews.org/route-views.jinx/bgpdata"        "jinx"
    "http://routeviews.org/route-views.linx/bgpdata"        "linx"
    "http://routeviews.org/route-views.napafrica/bgpdata"   "napafrica"
    "http://routeviews.org/route-views.nwax/bgpdata"        "nwax"
#    "http://routeviews.org/route-views.phoix/bgpdata"       "phoix"
    "http://routeviews.org/route-views.telxatl/bgpdata"     "telxatl"
    "http://routeviews.org/route-views.wide/bgpdata"        "wide"
    "http://routeviews.org/route-views.sydney/bgpdata"      "sydney"
    "http://routeviews.org/route-views.saopaulo/bgpdata"    "saopaulo"
    "http://routeviews.org/route-views2.saopaulo/bgpdata"   "saopaulo2"
    "http://routeviews.org/route-views.sg/bgpdata"          "sg"
    "http://routeviews.org/route-views.perth/bgpdata"       "perth"
    "http://routeviews.org/route-views.sfmix/bgpdata"       "sfmix"
    "http://routeviews.org/route-views.soxrs/bgpdata"       "soxrs"
#    "http://routeviews.org/route-views.mwix/bgpdata"        "mwix"
    "http://routeviews.org/route-views.rio/bgpdata"         "rio"
    "http://routeviews.org/route-views.fortaleza/bgpdata"   "fortaleza"
#    "http://routeviews.org/route-views.gixa/bgpdata"        "gixa"
)


for n in $(seq 0 2 $(expr "${#oix_list[@]}" - 1));
#for n in $(seq 0 2 2);
do
    #echo ${oix_list[$n]}
    #echo ${oix_list[$n+1]}
    uri=${oix_list[$n]}/${DATE}/RIBS/rib.${TIME}.bz2
    outpath=${BASE_DIR}/oix-mrt/rib.${oix_list[$n+1]}.${TIME}.mrt.bz2
    txtpath=${BASE_DIR}/oix-txt/rib.${oix_list[$n+1]}.${TIME}.txt
    echo "${oix_list[$n+1]}"
    #########
    
    wget -O $outpath $uri
    bgpdump -m -O ${txtpath} ${outpath}
    RAW_PATH=${txtpath} PARSED_DIR=${BASE_DIR}/oix-parsed ${PY_PATH} dumpfile_parser.py
done
