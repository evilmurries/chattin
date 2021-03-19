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
if paramCount() == 0:
  quit "Please specify server address"

let serverAddr = paramStr(1)
echo("Connecting to ", serverAddr)
let socket = newAsyncSocket()
asyncCheck connect(socket, serverAddr)

var messageFlowVar = spawn std.readLine()
while true:
  if messageFlowVar.isReady():
    let message = createMessage("Anonymous", ^messageFlowVar)
    asyncCheck socket.send(message)
    messageFlowVar = spawn stdin.readLine()
    asyncdispatch.poll()