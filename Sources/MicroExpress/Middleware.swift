//
//  Middleware.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

public typealias Next = ( Any... ) -> Void

public typealias Middleware = ( IncomingMessage, ServerResponse, @escaping Next ) -> Void

