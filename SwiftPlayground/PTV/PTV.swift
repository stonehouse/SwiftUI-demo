//
//  PTV.swift
//  SwiftPlayground
//
//  Created by alex on 3/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import CommonCrypto
import Combine

protocol DataAdapter {
    func request<E: Endpoint>(endpoint: E) async throws -> E.ResultType
}

/// This is where you can specify either 'default' or 'fixtures' version of the PTV client.
let ptv: PTV = .default

class PTV: ObservableObject {
    static let `default`: PTV = {
        let adapter = PTVAsyncAPIAdapter.default
        return PTV(adapter: adapter)
    }()
    
    let adapter: DataAdapter
    
    init(adapter: DataAdapter) {
        self.adapter = adapter
    }
    
    enum Errors: Error {
        case network(URLError)
        case encoding(Error)
        case other
    }
    
    func request<E: Endpoint>(endpoint: E) async throws -> E.ResultType {
        return try await adapter.request(endpoint: endpoint)
    }
}
