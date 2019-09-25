//
//  Routable.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation

protocol RootResultType: Codable {
    init()
}

protocol Endpoint {
    associatedtype ResultType: RootResultType
    
    var cache: Bool { get }
    var path: String { get }
    var query: [String: String] { get }
    func url(_ userId: Int) -> String?
}

extension Endpoint {
    func url(_ userId: Int) -> String? {
        var components = URLComponents()
        components.path = "/v\(PTV.API.apiVersion)/\(path)"
        components.queryItems = query.compactMap {
            return URLQueryItem(name: $0.key, value: $0.value)
        }
        components.queryItems?.append(URLQueryItem(name: "devid", value: "\(userId)"))
        
        return components.string
    }
}
