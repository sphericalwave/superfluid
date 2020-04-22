//
//  HTTPHandler.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//

import NIOHTTP1
import NIO

final class HTTPHandler: ChannelInboundHandler
{
    typealias InboundIn = HTTPServerRequestPart
    
    let router : Router
    
    init(router: Router) {
        self.router = router
    }
    
    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)
        
        switch reqPart {
        case .head(let header): //FIXME: Factor into method
            let req = IncomingMessage(header: header)
            let res = ServerResponse(channel: ctx.channel)
            
            // trigger Router
            router.handle(request: req, response: res) {
                (items : Any...) in // the final handler
                res.status = .notFound
                res.send(s: "No middleware handled the request!")
            }
            
        // ignore incoming content to keep it micro :-)
        case .body, .end: break
        }
    }
}
