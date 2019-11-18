ips=172.20.18.196:3306,172.20.18.197:3306,172.20.18.203:3306
current_inndex=0


ips=${ips//,/ }
iplist=($ips)
echo "集群列表:"$ips
echo "结点总数:3"
echo "当前结点编号:$current_inndex"
read -p "请输入其他已启动结点编号(0,1,2...,使用逗号或空格分隔,例如：0 2或0,2)" idxstring
idxstring=${idxstring//,/ }
idxlist=($idxstring)
otheraddress="gcomm://";
c=${#idxlist[@]}
if [ "$idxstring" =  "" ] || [ "$c" =  "0" ]; then
  otheraddress=$otheraddress','
else
	for ((i=0;i<c;i++))
	do 
	    idx=${idxlist[i]}
	    ((cpport=4567+idx))
	    tmp=${iplist[idx]}
	    tmp=${tmp//:/ }
	    ipport=($tmp)
	    otheraddress=$otheraddress${ipport[0]}':'$cpport','
	done
fi
echo $otheraddress
./mysqld start --wsrep-cluster-address=$otheraddress