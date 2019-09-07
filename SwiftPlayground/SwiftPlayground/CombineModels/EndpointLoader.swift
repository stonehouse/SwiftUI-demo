//
//  asdf.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

protocol EndpointLoader: ObservableObject {
    associatedtype EndpointType: Endpoint
    
    var endpoint: EndpointType { get }
    var cancellable: AnyCancellable? { get set }
    func receive(value: EndpointType.ResultType)
    func load()
}

extension EndpointLoader {
    func load() {
        cancellable = ptv.request(route: endpoint)
                        .receive(on: RunLoop.main)
                        .sink(receiveCompletion: { c in
                            switch c {
                            case .failure(let err):
                                print("Error: \(err)")
                            case .finished: break
                            }
                        }, receiveValue: { value in
                            self.receive(value: value)
                        })
    }
}
