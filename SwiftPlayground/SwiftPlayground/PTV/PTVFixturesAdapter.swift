//
//  PTVFixturesAdapter.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

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
    func request<T>(route: T) -> AnyPublisher<T.ResultType, PTV.Errors> where T : Endpoint {
        AnyPublisher(Just(fixture(for: route)).mapError({ _ in PTV.Errors.other }))
    }
    
    func fixture<T: Endpoint>(for route: T) -> T.ResultType {
        if route is PTV.API.RouteTypes {
            return loadFixture("route_types")
        } else if route is PTV.API.Routes {
            return loadFixture("routes")
        } else if route is PTV.API.StopsOnRoute {
            return loadFixture("stops_route")
        }
        
        return T.ResultType()
    }
}

// MARK: Fixtures

extension RouteTypes {
    static var fixture: RouteTypes {
        let fixture = RouteTypes()
        fixture.routeTypes = fixturesAdapter.fixture(for: fixture.endpoint).routeTypes
        return fixture
    }
}

extension Routes {
    static var fixture: Routes {
        let fixture = Routes(routeTypes: [])
        fixture.routes = fixturesAdapter.fixture(for: fixture.endpoint).routes
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
        fixture.stops = fixturesAdapter.fixture(for: fixture.endpoint).stops
        return fixture
    }
}
