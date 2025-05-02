##Historicly data fetch 
curl -u cloud-platform:wysgu0-rEjzox-densyc -H "Content-Type: application/json" -d '{"ifid": 41, "select_clause": "*", "where_clause": "IPV4_SRC_ADDR = 192.168.56.1", "begin_time_clause": 1590480290, "end_time_clause": 1590480590, "maxhits_clause": 10}' http://172.16.8.112:3000/lua/pro/rest/v2/get/db/flows.lua
