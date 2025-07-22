grafana div copilot【GDC】

# 为什么做这个项目
AI时代，对于个人需要有个全面满足自己需求的工具，这个工具需要有高度定制功能。

而grafana刚好可以满足，那么我先用grafana满足自己的信息采集和工具使用的需求，然后再推而广之，满足更多人的需求。

# 原则
1. 尽量使用开源软件，避免收费软件。
2. 只做我会用的工具，频率先做一周至少会用一次的功能。
3. 已经有的开源工具就不要造轮子。
4. 最小化成本实现原则。


# 主要功能
## 获取中国卫星每日股价
api接口选择：

https://www.alphavantage.co/documentation/

实际请求地址：

https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=600118.SHH&outputsize=compact&apikey=demo

实现思路：

通过宝塔后台的定时任务，每天定时请求这个接口，获取数据，然后保存到数据库中。

再通过grafana的插件查询数据库，展示这个数据。



