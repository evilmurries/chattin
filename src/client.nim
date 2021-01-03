import os, threadpool

echo "Chat application started"
if paramCount() == 0:
  quit "Please specify server address"

let serverAddr = paramStr(1)
echo serverAddr

while true:
  let message = spawn stdin.readLine()
  echo("Sending \"", ^message, "\"")
