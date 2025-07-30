


#获取聚合股票密钥
apikey=XXX
echo "apikey:$apikey"


nowPri=$(curl -s "http://web.juhe.cn/finance/stock/hs?key=$apikey&gid=sh600118&type=" | jq -r '.["result"][0]["data"]["nowPri"]')
echo "nowPri:$nowPri"

nowDate=$(curl -s "http://web.juhe.cn/finance/stock/hs?key=$apikey&gid=sh600118&type=" | jq -r '.["result"][0]["data"]["date"]')
echo "nowDate:$nowDate"

#如果执行失败打印异常结束
if [ $? -ne 0 ]; then printf "error\n"; exit 1; fi

#如果nowPri不为空插入数据库
if [ ! -z "$nowPri" ]; then

  # 定义变量
  username="my_metrics"
  password="my_metrics"
  host="localhost"
  database="my_metrics"
  code="600118.SHH"

  # 使用mysql命令插入数据
  mysql -u $username -p$password -h $host $database -e "INSERT INTO t_stock_metric(code, create_time,close_value) VALUES ('$code', '$nowDate', '$nowPri');"

fi

