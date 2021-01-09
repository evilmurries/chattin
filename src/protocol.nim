import json

type
  Message* = object
    username*: string
    message*: string

proc parseMessage*(data: string): Message =
  let dataJson = parseJson(data)
  result.username = dataJson["username"].getStr()
  result.message = dataJson["message"].getStr()

when isMainModule:
  echo "Running tests"

  echo "Pass assertion"
  block:
    let data = """{"username": "John", "message": "Hi!"}"""
    let parsed = parseMessage(data)
    
    doAssert parsed.username == "John"
    doAssert parsed.message == "Hi!"

  echo "Fail assertion"
  block:
    let data = """{"username": "Jane", "message": "Goodbye!"}"""
    let parsed = parseMessage(data)

    try:
      doAssert parsed.username == "Jane"
      doAssert parsed.message == "Hi!"
    except AssertionError:
      doAssert true
    except:
      doAssert false

  echo "Malformed input"
  block:
    let data = """foobar"""
    try:
      let parsed = parseMessage(data)
      doAssert false
    except JsonParsingError:
      doAssert true
    except:
      doAssert false

  echo "All tests passed"