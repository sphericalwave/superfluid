//
//  HTTPHandler.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

import NIOHTTP1
import NIO

final class HTTPReceiver: ChannelInboundHandler
{
    typealias InboundIn = HTTPServerRequestPart
    let router : Router
    
    init(router: Router) {
        self.router = router
    }
    
    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)
        switch reqPart {
        case .head(let header): transmit(header: header, channel: ctx.channel)
        case .body: break //FIXME:
        case .end: break  //FIXME:
        }
    }
    
    //FIXME: Push into transmitter?
    func transmit(header: HTTPRequestHead, channel: Channel) {
        let req = IncomingMessage(header: header)
        let res = ServerResponse(channel: channel)
        
        //FIXME: why trigger Router?
        router.handle(request: req, response: res) { (items : Any...) in // the final handler
            res.status = .notFound
            res.send(s: "No middleware handled the request!")
        }
    }
}
