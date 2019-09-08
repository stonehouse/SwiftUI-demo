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
    func request<T: Endpoint>(endpoint: T) -> AnyPublisher<T.ResultType, PTV.Errors>
}

let ptv: PTV = .default

class PTV: ObservableObject {
    static let `default`: PTV = {
        let adapter = PTVAPIAdapter.default
        return PTV(adapter: adapter)
    }()
    
    let adapter: DataAdapter
    
    init(adapter: DataAdapter) {
        self.adapter = adapter
    }
    
    enum Errors: Error {
        case network(URLError)
        case other
    }
    
    func request<T: Endpoint>(route: T) -> AnyPublisher<T.ResultType, Errors>  {
        return adapter.request(endpoint: route)
    }
}
