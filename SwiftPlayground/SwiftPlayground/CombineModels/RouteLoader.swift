//
//  asdf.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

private let token = PTV.AccessToken( key: "27df7af0-a2e8-4dc9-805e-755035b5492d", developerID: 3001313)
let ptv = PTV(token: token)

protocol RouteLoader: ObservableObject {
    associatedtype Route: Routable
    
    var loading: Bool { get set }
    var cancellable: AnyCancellable? { get set }
    func receive(value: Route.ResultType)
    func resume(_ route: Route)
}

extension RouteLoader {
    func resume(_ route: Route) {
        loading = true
        cancellable = ptv.request(route: route)
                        .receive(on: RunLoop.main)
                        .sink(receiveCompletion: { c in
                            self.loading = false
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
