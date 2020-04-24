//
//  query.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

import Foundation

fileprivate let paramDictKey = "de.zeezide.µe.param"

//FIXME: free function for http://localhost:1337/?text=Awesome.
/// A middleware which parses the URL query parameters. You can then access them using: req.param("id")
public func querystring(req: IncomingMessage, res: ServerResponse, next: @escaping Next) {
    // use Foundation to parse the `?a=x` parameters
    if let queryItems = URLComponents(string: req.header.uri)?.queryItems {
        req.userInfo[paramDictKey] = Dictionary(grouping: queryItems, by: { $0.name }).mapValues { $0.compactMap({ $0.value }).joined(separator: ",") }
    }
    next()      // pass on control to next middleware
}

public extension IncomingMessage {
    
    /// Access query parameters, like:
    ///
    ///     let userID = req.param("id")
    ///     let token  = req.param("token")
    ///
    func param(id: String) -> String? {
        return (userInfo[paramDictKey] as? [String : String])? [id]
    }
}

