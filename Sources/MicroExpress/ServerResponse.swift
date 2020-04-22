// File: ServerResponse.swift - create this in Sources/MicroExpress

import NIO
import NIOHTTP1

open class ServerResponse {
    
    public  var status         = HTTPResponseStatus.ok
    public  var headers        = HTTPHeaders()
    public  let channel        : Channel
    private var didWriteHeader = false
    private var didEnd         = false
    
    public init(channel: Channel) {
        self.channel = channel
    }
    
    /// An Express like `send()` function.
    open func send(_ s: String) {
        flushHeader()
        
        let utf8   = s.utf8
        var buffer = channel.allocator.buffer(capacity: utf8.count)
        buffer.write(bytes: utf8)
        
        let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
        
        _ = channel.writeAndFlush(part)
            .mapIfError(handleError)
            .map { self.end() }
    }
    
    /// Check whether we already wrote the response header.
    /// If not, do so.
    func flushHeader() {
        guard !didWriteHeader else { return } // done already
        didWriteHeader = true
        
        let head = HTTPResponseHead(version: .init(major:1, minor:1),
                                    status: status, headers: headers)
        let part = HTTPServerResponsePart.head(head)
        _ = channel.writeAndFlush(part).mapIfError(handleError)
    }
    
    func handleError(_ error: Error) {
        print("ERROR:", error)
        end()
    }
    
    func end() {
        guard !didEnd else { return }
        didEnd = true
        _ = channel.writeAndFlush(HTTPServerResponsePart.end(nil))
            .map { self.channel.close() }
    }
}

public extension ServerResponse {
    
    /// A more convenient header accessor. Not correct for
    /// any header.
    public subscript(name: String) -> String? {
        set {
            assert(!didWriteHeader, "header is out!")
            if let v = newValue {
                headers.replaceOrAdd(name: name, value: v)
            }
            else {
                headers.remove(name: name)
            }
        }
        get {
            return headers[name].joined(separator: ", ")
        }
    }
}

import Foundation

public extension ServerResponse {
    
    /// Send a Codable object as JSON to the client.
    func json<T: Encodable>(_ model: T) {
        // create a Data struct from the Codable object
        let data : Data
        do {
            data = try JSONEncoder().encode(model)
        }
        catch {
            return handleError(error)
        }
        
        // setup JSON headers
        self["Content-Type"]   = "application/json"
        self["Content-Length"] = "\(data.count)"
        
        // send the headers and the data
        flushHeader()
        
        var buffer = channel.allocator.buffer(capacity: data.count)
        buffer.write(bytes: data)
        let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
        
        _ = channel.writeAndFlush(part)
            .mapIfError(handleError)
            .map { self.end() }
    }
}

import mustache

public extension ServerResponse {
    
    //https://www.alwaysrightinstitute.com/microexpress-nio-templates/
    func render(pathContext: String = #file, _ template : String, _ options: Any? = nil)
    {
        let res = self
        
        // Locate the template file
        let path = self.path(to: template, ofType: "mustache", in: pathContext) ?? "/dummyDoesNotExist"
        
        // Read the template file
        fs.readFile(path) { err, data in
            guard var data = data else {
                res.status = .internalServerError
                return res.send("Error: \(err as Optional)")
            }
            
            data.write(bytes: [0]) // cstr terminator
            
            // Parse the template
            let parser = MustacheParser()
            let tree: MustacheNode = data.withUnsafeReadableBytes {
                let ba  = $0.baseAddress!
                let bat = ba.assumingMemoryBound(to: CChar.self)
                return parser.parse(cstr: bat)
            }
            
            // Render the response
            let result = tree.render(object: options)
            
            // Deliver
            res["Content-Type"] = "text/html"
            res.send(result)
        }
    }
    
    private func path(to resource: String, ofType: String, in pathContext: String) -> String?
    {
        #if os(iOS) && !arch(x86_64) // iOS support, FIXME: blocking ...
        return Bundle.main.path(forResource: template, ofType: "mustache")
        #else
        var url = URL(fileURLWithPath: pathContext)
        url.deleteLastPathComponent()
        url.appendPathComponent("templates", isDirectory: true)
        url.appendPathComponent(resource)
        url.appendPathExtension("mustache")
        print(url.description)
        return url.path
        #endif
    }
}
