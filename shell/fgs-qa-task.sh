#非共识问题日报
# shellcheck disable=SC1090
. ~/apikey.sh

apikey=$zhipu_apikey

echo "apikey:$apikey"

# 获取1-500页之间的随机数
now=$((RANDOM % 1000 + 1))


random_topic='阅读中华书局《红楼梦》第'"$now"'页，讲了什么，20个字概括'

echo "random_topic:$random_topic"

#使用免费的智谱api，获取每日非共识问题
response=$(curl -s --request POST \
  --url https://open.bigmodel.cn/api/paas/v4/chat/completions \
  --header "Authorization: $apikey" \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "glm-4.5-flash",
  "do_sample": true,
  "stream": false,
  "thinking": {
    "type": "disabled"
  },
  "temperature": 0.6,
  "top_p": 0.95,
  "response_format": {
    "type": "json_object"
  },
  "messages": [
    {
      "role": "user",
      "content": "'"$random_topic"'"
    }
  ]
}')
echo "response:$response"

# 提取话题答案
topic=$(printf "%s" $response  | jq -r '.choices[0].message.content' | jq -r '.answer')


echo "topic:$topic"

# 提前话题相关的非共识答案
topic_thinking="关于「${topic}」的反共识思考,要求100字以内"
echo "topic_thinking:$topic_thinking"

response=$(curl -s --request POST \
  --url https://open.bigmodel.cn/api/paas/v4/chat/completions \
  --header "Authorization: $apikey" \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "glm-4.5-flash",
  "do_sample": true,
  "stream": false,
  "thinking": {
    "type": "disabled"
  },
  "temperature": 0.6,
  "top_p": 0.95,
  "response_format": {
    "type": "json_object"
  },
  "messages": [
    {
      "role": "user",
      "content": "'"$topic_thinking"'"
    }
  ]
}')

topic_answer=$(printf "%s" $response | jq -r '.choices[0].message.content' | jq -r '.answer')
echo "topic_answer:$topic_answer"

#发短信
sms_response=$(curl -s -d "appid=15717&to=13524080425&content=【上海有问就答】非共识答案，$topic_answer&signature=$mysubmail_signature" https://api-v4.mysubmail.com/sms/send.json)
echo "sms_response:$sms_response"
#存数据库
if [ ! -z "$topic_answer" ]; then

  # 定义变量
  username="my_metrics"
  password="my_metrics"
  host="localhost"
  database="my_metrics"
  code="fgs-qa"

  # 使用mysql命令插入数据
  mysql -u $username -p$password -h $host $database -e "INSERT INTO t_llm_report(code, create_time,title, content) VALUES ('$code', now(), '$topic_thinking', '$topic_answer');"

fi




