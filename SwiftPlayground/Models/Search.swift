//
//  Search.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 24/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

class Search: ObservableObject {
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
    
    @Published var stops: [Stop] = []
    @Published var routes: [Route] = []
    @Published var results: [Result] = []
    private let subject = PassthroughSubject<String, Error>()

    /// For fixtures
    init(search: PTV.Models.Search) {
        receive(value: search)
    }
    
    init() {
    }
    
    func update(search: String) {
        subject.send(search)
    }
    
    private func receive(value: PTV.Models.Search) {
        stops = value.stops
        routes = value.routes
        results = (value.stops.map { Result.stop($0) } + value.routes.map { Result.route($0) })
                        .sorted(by: { $0.name < $1.name })
    }
    
    @MainActor
    func bind() async {
        do {
            for try await searchTerm in subject.values {
                let searchResult = try await ptv.request(endpoint: PTV.API.Search(searchTerm: searchTerm))
                self.receive(value: searchResult)
            }
        } catch _ {
            
        }
    }
}
