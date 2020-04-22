//
//  main.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

import NIO

let router = Router()
let eventLoops = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let threadPool = BlockingIOThreadPool(numberOfThreads: 4)
let fileIO = NonBlockingFileIO(threadPool: threadPool)
let files = Files(eventLoops: eventLoops, threadPool: threadPool, fileIO: fileIO)
let app = WebApp(host: "localhost", port: 8080, router: router, eventLoops: eventLoops)

//TODO: Why is this here?
//fs.readFile("/etc/passwd") { err, data in
//  guard let data = data else { return print("Failed:", err) }
//  print("Read passwd:", data)
//}

//FIXME: what is CORS? // Reusable middleware up here
app.router.use(middleware: querystring, cors(allowOrigin: "*"))

// Logging
app.router.use { req, res, next in
    print("\(req.header.method):", req.header.uri)
    next() // continue processing
}

//FIXME: Router Encapsulation Violations
app.router.get(path: "/todos") { _, res, _ in
    res.render("Todolist", [ "title": "DoIt!", "todos": todos ], files: files)
}

//FIXME: Router Encapsulation Violations
app.router.get(path: "/todomvc") { _, res, _ in
    // send JSON to the browser
    res.json(model: todos)
}

//FIXME: Router Encapsulation Violations
app.router.get(path: "/moo") { req, res, next in
    res.send(s: "Muhhh")
}

//FIXME: Router Encapsulation Violations
app.router.get { req, res, _ in
    // `param` is provided by querystring
    let text = req.param(id: "text") ?? "Schwifty"
    res.send(s: "Hello, \(text) world!")
}

app.listen()

