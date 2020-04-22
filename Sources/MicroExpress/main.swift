// File: main.swift - Add to existing file
let router = Router()
let app = Express(host: "localhost", port: 8080, router: router)

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
  res.render("Todolist", [ "title": "DoIt!", "todos": todos ])
}

app.router.get(path: "/todomvc") { _, res, _ in
  // send JSON to the browser
  res.json(todos)
}

app.router.get(path: "/moo") { req, res, next in
  res.send("Muhhh")
}

app.router.get { req, res, _ in
  // `param` is provided by querystring
  let text = req.param("text")
          ?? "Schwifty"
  res.send("Hello, \(text) world!")
}

app.listen()

