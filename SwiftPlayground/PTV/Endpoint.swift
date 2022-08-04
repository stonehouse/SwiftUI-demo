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

protocol Endpoint<ResultType> {
    associatedtype ResultType: RootResultType
    
    var cache: Bool { get }
    var path: String { get }
    var query: [String: String] { get }
}
