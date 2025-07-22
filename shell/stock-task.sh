

#获取最新close股价的sh脚本

#第一步获取当前日期减一天
#date=$(date -d "1 day ago" +%Y-%m-%d)
date=$(date +%Y-%m-%d)

#第二步获取close股价
apikey=$(echo $ALPHAVANTAGE_API_KEY)
close=$(curl -s "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=600118.SHH&outputsize=compact&apikey=$apikey" | jq -r '.["Time Series (Daily)"]["'"$date"'"]["4. close"]')


#第三步，如果执行失败打印异常结束
if [ $? -ne 0 ]; then printf "error\n"; exit 1; fi

#第四步，如果close不为空插入数据库
if [ ! -z "$close" ]; then

  # 定义变量
  username="my_metrics"
  password="my_metrics"
  host="localhost"
  database="my_metrics"
  code="600118.SHH"

  # 使用mysql命令插入数据
  mysql -u $username -p$password -h $host $database -e "INSERT INTO t_stock_metric(code, create_time,close_value) VALUES ('$code', '$date', '$close');"

fi
