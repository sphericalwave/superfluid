// File: main.swift - Add to existing file
import NIO

let router = Router()
let eventLoops = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let threadPool = BlockingIOThreadPool(numberOfThreads: 4)
 //FIXME:        tp.start()
 let fileIO = NonBlockingFileIO(threadPool: threadPool)

let files = Files(eventLoops: eventLoops, threadPool: threadPool, fileIO: fileIO)
let app = Express(host: "localhost", port: 8080, router: router, eventLoops: eventLoops)

//fs.readFile("/etc/passwd") { err, data in
//  guard let data = data else { return print("Failed:", err) }
//  print("Read passwd:", data)
//}

//FIXME: Router Encapsulation Violations

// Reusable middleware up here
app.router.use(querystring, cors(allowOrigin: "*"))

// Logging
app.router.use { req, res, next in
  print("\(req.header.method):", req.header.uri)
  next() // continue processing
}

app.router.get(path: "/todos") { _, res, _ in
    res.render("Todolist", [ "title": "DoIt!", "todos": todos ], files: files)
}

app.router.get(path: "/todomvc") { _, res, _ in
  // send JSON to the browser
    res.json(model: todos)
}

app.router.get(path: "/moo") { req, res, next in
    res.send(s: "Muhhh")
}

app.router.get { req, res, _ in
  // `param` is provided by querystring
  let text = req.param("text")
          ?? "Schwifty"
    res.send(s: "Hello, \(text) world!")
}

app.listen()

