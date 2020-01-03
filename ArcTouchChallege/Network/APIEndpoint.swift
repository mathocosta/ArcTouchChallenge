//
//  APIEndpoint.swift
//  ArcTouchChallege
//
//  Created by Matheus Oliveira Costa on 02/01/20.
//  Copyright © 2020 mathocosta. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "codechallenge.arctouch.com"
        components.path = path

        return components.url!
    }
}

extension Endpoint {
    static func firstQuestion() -> Endpoint {
        return Endpoint(path: "/quiz/1")
    }
}
