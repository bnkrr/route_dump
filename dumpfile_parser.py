import os
import ipaddress

from collections import Counter

# format
# BGP Protocol|X|timestamp|W/A/B (withdrawal/announcement/routing table)|Peer IP (address of the monitor)|
# ASN of monitor|Prefix|ASPath|Origin Protocol (typically always IGP)|Next Hop|LocalPref|MED|
# Community strings|Atomic Aggregator|Aggregator
#
# TABLE_DUMP2|0|1575849600|B|103.102.5.1|
# 131477|0.0.0.0/0|131477 58879|IGP|103.102.5.1|0|0|
#  |NAG||

# TABLE_DUMP2|1585670400|B|45.65.244.1|265721|1.0.0.0/24|265721 23520 13335|IGP|45.65.244.1|0|0||NAG|13335 108.162.211.1|

def init_file_handler(path):
    f = open(path, 'w')
    f.write('|'.join(['status','prefix','next_hop','metric','loc_pref','weight','path','origin'])+'\n')
    f.write('===\n')
    return f

def parse(raw_path, parsed_dir):
    file_handlers = {}
    c = Counter()
    with open(raw_path) as f_raw:
        for line in f_raw:
            try:
                _, _, _, ip, asn, prefix, aspath, origin, next_hop, loc_pref, med, _, _, _, _ = line.rstrip('\n').split('|')
            except:
                _, _, _, ip, asn, prefix, _, aspath, origin, next_hop, loc_pref, med, _, _, _, _ = line.rstrip('\n').split('|')

            try:
                prefix_version = ipaddress.ip_network(prefix).version
            except:
                print(line, end='')
                continue
            
            fn = '{:d}/{:s}-{:s}'.format(prefix_version, asn, ip)
            if fn not in file_handlers:
                file_handlers[fn] = init_file_handler(os.path.join(parsed_dir, fn))
            fout = file_handlers[fn]
            fout.write('|'.join(['', prefix, next_hop, '', loc_pref, '',aspath, origin])+'\n')
    for name, handler in file_handlers.items():
        handler.close()

#RAW_PATH = '/mnt/sda/metadata/dns-route/route-table/20191209/ripe.rrc00.txt'
#PARSED_DIR = '/mnt/sda/metadata/dns-route/route-table/20191209/parsed.ripe/'
RAW_PATH = os.environ['RAW_PATH']
PARSED_DIR = os.environ['PARSED_DIR']

parse(RAW_PATH, PARSED_DIR)
