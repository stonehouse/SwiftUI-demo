//
//  PTVFixturesAdapter.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation

private let fixturesAdapter = PTVFixturesAdapter()
extension PTV {
    static var fixtures: PTV {
        PTV(adapter: fixturesAdapter)
    }
}

private func loadFixture<ResultType: Codable>(_ name: String) -> ResultType {
    let bundle = Bundle.main
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    guard let path = bundle.path(forResource: name, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        fatalError("No fixtures for type \(ResultType.self)")
    }
    
    do {
        return try decoder.decode(ResultType.self, from: data)
    } catch let e {
        print("Error loading fixture \(e)")
        print(String(data: data, encoding: .utf8) ?? "empty")
        fatalError("Error parsing fixture of type \(ResultType.self)")
    }
}

class PTVFixturesAdapter: DataAdapter {
    func request<T: Endpoint>(endpoint: T) async -> T.ResultType {
        fixture(for: endpoint)
    }
    
    func fixture<T: Endpoint>(for route: T) -> T.ResultType {
        if route is PTV.API.RouteTypes {
            return loadFixture("route_types")
        } else if route is PTV.API.Routes {
            return loadFixture("routes")
        } else if route is PTV.API.StopsOnRoute {
            return loadFixture("stops_route")
        } else if route is PTV.API.DeparturesAtStop {
            return loadFixture("departures")
        } else if route is PTV.API.Directions {
            return loadFixture("directions")
        }
        
        return T.ResultType()
    }
}

// MARK: Fixtures

extension RouteTypes {
    static var fixture: RouteTypes {
        let fixture = RouteTypes()
        fixture.routeTypes = fixturesAdapter.fixture(for: PTV.API.RouteTypes()).routeTypes
        return fixture
    }
}

extension Routes {
    static var fixture: Routes {
        let fixture = Routes(routeTypes: [])
        fixture.routes = fixturesAdapter.fixture(for: PTV.API.Routes(routeTypes: [])).routes
        return fixture
    }
}

extension PTV.Models.Route {
    static var fixture: PTV.Models.Route {
        loadFixture("route")
    }
}

extension StopsOnRoute {
    static var fixture: StopsOnRoute {
        let fixture = StopsOnRoute(route: .fixture)
        fixture.stops = fixturesAdapter.fixture(for: PTV.API.StopsOnRoute(route: .fixture)).stops
        return fixture
    }
}

extension PTV.Models.Stop {
    static var fixture: PTV.Models.Stop {
        loadFixture("stop")
    }
}

extension PTV.Models.Directions {
    static var fixture: PTV.Models.Directions {
        loadFixture("directions")
    }
}

extension Departures {
    static var fixture: Departures {
        let now = Date(timeIntervalSince1970: 1567778879)
        let fixture = Departures(stop: .fixture, route: .fixture, now: now, filterOld: false)
        fixture.departures = fixturesAdapter.fixture(for: PTV.API.DeparturesAtStop(stop: .fixture, route: .fixture)).departures
        fixture.directions = PTV.Models.Directions.fixture.directions
        return fixture
    }
}

extension PTV.Models.Search {
    static var fixture: PTV.Models.Search {
        loadFixture("search")
    }
}

extension Search {
    static var fixture: Search {
        Search(search: .fixture)
    }
}
