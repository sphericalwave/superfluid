//
//  CORS.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

//FIXME: Free Function
public func cors(allowOrigin origin: String) -> Middleware {
    return { req, res, next in
        res["Access-Control-Allow-Origin"]  = origin
        res["Access-Control-Allow-Headers"] = "Accept, Content-Type"
        res["Access-Control-Allow-Methods"] = "GET, OPTIONS"
        
        // handle the options
        if req.header.method == .OPTIONS {
            res["Allow"] = "GET, OPTIONS"
            res.send(s: "")
        }
        else { next() } // we set the proper headers
    }
}

