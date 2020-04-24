//
//  IncomingMessage.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

import NIOHTTP1

open class IncomingMessage
{
    public let header: HTTPRequestHead
    public var userInfo = [String : Any]()  //FIXME: Be Immutable
    
    init(header: HTTPRequestHead) {
        self.header = header
    }
}
