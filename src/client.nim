import os, asyncdispatch, asyncnet, protocol, threadpool

proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =
  echo("Connecting to ", serverAddr)
  await socket.connect(serverAddr, 7687.Port)
  echo("Connection made")
  while true:
    let line = await socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, ": ", parsed.message)

echo "Chat application started"
if paramCount() < 2:
  quit "Please specify server address and user name"

let serverAddr = paramStr(1)
let username = paramStr(2)
echo("Connecting to ", serverAddr)
let socket = newAsyncSocket()
asyncCheck connect(socket, serverAddr)

var messageFlowVar = spawn stdin.readLine()
while true:
  if messageFlowVar.isReady():
    let message = createMessage(username, ^messageFlowVar)
    asyncCheck socket.send(message)
    messageFlowVar = spawn stdin.readLine()
    asyncdispatch.poll()