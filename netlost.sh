#/bin/sh

#
# drop some packets to simulate network traffic jam
# Yuwen Dai, January 15 2013
# 
HOST=26.3.22.1

function clean_up
{
# restore iptable rules
#    iptables -D OUTPUT  -d $HOST -p tcp  -j DROP
iptables -D INPUT -p tcp --dport 5672 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -D INPUT -p tcp --dport 25672 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP    
iptables -D INPUT -p tcp --dport 4369 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -D INPUT -p tcp --dport 2181 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -D INPUT -p tcp --dport 58095 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
    exit
}

function get_random
{
    local R=$((${RANDOM}*${1}/32767))
    R=$((R+1))
    echo ${R}
}
function sleep_random
{
    local E=$((${RANDOM}*${1}/32767))
    E=$((E+1+5))
    echo ${E}
}
# user can use `ctrl-c' to exit the loop
trap clean_up SIGHUP SIGINT SIGTERM

# default interval time is 5 seconds
if [ $# -lt 1 ];then
    INTERVAL=5
else
    INTERVAL=${1}
fi

#
# loop
#
while [ 0 ];do
# Get a random number: [1, INTERVAL]
    R=$(get_random ${INTERVAL})
# Drop TCP ACK segments
echo "######################start ${R} secend!########################"
#    iptables -A OUTPUT  -d $HOST -p tcp -j DROP
iptables -A INPUT -p tcp --dport 5672 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -A INPUT -p tcp --dport 25672 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP                          
iptables -A INPUT -p tcp --dport 4369 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -A INPUT -p tcp --dport 2181 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -A INPUT -p tcp --dport 58095 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
#iptables -A FORWARD  -s $HOST -j DROP
#iptables --list-rules
# let the rule take effect for sometime
    sleep ${R}
# delete the rule
#    iptables -D OUTPUT  -d $HOST -p tcp -j DROP
iptables -D INPUT -p tcp --dport 5672 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -D INPUT -p tcp --dport 25672 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP                          
iptables -D INPUT -p tcp --dport 4369 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -D INPUT -p tcp --dport 2181 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
iptables -D INPUT -p tcp --dport 58095 --tcp-flags SYN,ACK,FIN,RST ACK -j DROP
echo "@@@@@@@@@@@@@@@@@@@@@@@@stop@@@@@@@@@@@@@@@@@@@@@@@@"
iptables --list-rules
# No rule for sometime
R=$(get_random ${INTERVAL})
    sleep $((R+5))
done
