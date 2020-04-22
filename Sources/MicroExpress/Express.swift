// File: Express.swift - create this in Sources/MicroExpress

import Foundation
import NIO
import NIOHTTP1

//let loopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)  //FIXME: Global

open class Express
{
    let router: Router
    let port: Int
    let host: String
    let eventLoops: MultiThreadedEventLoopGroup
    
    init(host: String, port: Int, router: Router, eventLoops: MultiThreadedEventLoopGroup) {
        self.host = host
        self.port = port
        self.router = router
        self.eventLoops = eventLoops
    }
    
    open func listen() {
        let reuseAddrOpt = ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR)
        let bootstrap = ServerBootstrap(group: eventLoops)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(reuseAddrOpt, value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline().then {
                    channel.pipeline.add(handler: HTTPHandler(router: self.router))
                }
        }
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(reuseAddrOpt, value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
        
        do {
            let serverChannel = try bootstrap.bind(host: host, port: port).wait()
            print("Server running on:", serverChannel.localAddress!)
            try serverChannel.closeFuture.wait() // runs forever
        }
        catch { fatalError("failed to start server: \(error)") }
    }
}

