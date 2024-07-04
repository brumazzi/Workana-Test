json.status @status
json.message @message

json.token @token if @status == 200
