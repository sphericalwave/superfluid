//
//  Todo.swift
//  MicroExpress
//
//  Created by Aaron Anthony on 2020-04-22.
//  Copyright © 2020 Spherical Wave Engineering. All rights reserved.
//

struct Todo : Codable
{
  var id        : Int
  var title     : String
  var completed : Bool
}

//FIXME: Global
// Our fancy todo "database". Since it is immutable it is webscale and lock free, if not useless.
let todos = [ Todo(id: 42,   title: "Buy beer", completed: false),
              Todo(id: 1337, title: "Buy more beer", completed: false),
              Todo(id: 88,   title: "Drink beer", completed: true) ]

