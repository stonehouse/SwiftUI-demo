//
//  Search.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 24/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

class Search: EndpointLoader {
    typealias EndpointType = PTV.API.Search
    typealias Stop = PTV.Models.Stop
    typealias Route = PTV.Models.Route
    
    enum Result: Identifiable {
        case stop(Stop), route(Route)
        
        var name: String {
            switch self {
            case .stop(let stop):
                return stop.stopName
            case .route(let route):
                return route.routeName
            }
        }
        
        var id: Int {
            self.name.hashValue
        }
    }
    
    let endpoint = EndpointType(searchTerm: "") // Not used
    var cancellables: [AnyCancellable] = []
    @Published var stops: [Stop] = []
    @Published var routes: [Route] = []
    @Published var results: [Result] = []
    var cancellable: AnyCancellable?
    private let subject = PassthroughSubject<String, PTV.Errors>()

    /// For fixtures
    init(search: EndpointType.ResultType) {
        receive(value: search)
    }
    
    init() {
        cancellable = subject
            .flatMap({ searchTerm in
                ptv.request(route: EndpointType(searchTerm: searchTerm))
            })
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [unowned self] searchResult in
                self.receive(value: searchResult)
            })
    }
    
    func update(search: String) {
        subject.send(search)
    }
    
    func receive(value: EndpointType.ResultType) {
        stops = value.stops
        routes = value.routes
        results = (value.stops.map { Result.stop($0) } + value.routes.map { Result.route($0) })
                        .sorted(by: { $0.name < $1.name })
    }
}
