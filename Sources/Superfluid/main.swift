//
//  main.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

import NIO

//let todo: (IncomingMessage, ServerResponse, @escaping Next) -> Void = { request, response, next in
//    response.render("Todolist", [ "title": "DoIt!", "todos": todos ], files: files)
//}

let router = Router()

router.use(middleware: querystring, cors(allowOrigin: "*"))  //FIXME: what is CORS? // Reusable middleware up here

// Logging
router.use { req, res, next in
    print("\(req.header.method):", req.header.uri)
    next() // continue processing
}

router.get(path: "/todos") { _, res, _ in
    res.render("Todolist", [ "title": "DoIt!", "todos": todos ], files: files)
}

router.get(path: "/todomvc") { _, res, _ in
    res.json(model: todos)      // send JSON to the browser
}

router.get(path: "/moo") { req, res, next in
    res.send(s: "Muhhh")
}

router.get { req, res, _ in
    let text = req.param(id: "text") ?? "Schwifty"      // `param` is provided by querystring
    res.send(s: "Hello, \(text) world!")
}

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

app.listen()

