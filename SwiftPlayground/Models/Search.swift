//
//  Search.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 24/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import AsyncAlgorithms

class Search: ObservableObject {
    typealias Stop = PTV.Models.Stop
    typealias Route = PTV.Models.Route
    
    enum Result: Identifiable {
        case stop(Stop), route(Route)
        
        var id: Int {
            self.name.hashValue
        }
    }
    
    @Published var stops: [Stop] = []
    @Published var routes: [Route] = []
    @Published var results: [Result] = []
    @Published var searchTerm: String = ""

    /// For fixtures
    init(search: PTV.Models.Search = .init()) {
        update(value: search)
    }
    
    private func update(value: PTV.Models.Search) {
        stops = value.stops
        routes = value.routes
        results = (value.stops.map { Result.stop($0) } + value.routes.map { Result.route($0) })
                        .sorted(by: { $0.name < $1.name })
    }
    
    @MainActor
    func bind() async {
        // Clear results
        update(value: .init())
        
        do {
            for try await searchTerm in $searchTerm.values
                .debounce(for: .milliseconds(500))
                .filter({ $0.count > 2 }) {
                let searchResult = try await ptv.request(endpoint: PTV.API.Search(searchTerm: searchTerm))
                self.update(value: searchResult)
            }
        } catch _ {
            
        }
    }
}
