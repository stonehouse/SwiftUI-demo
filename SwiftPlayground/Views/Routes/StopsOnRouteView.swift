//
//  StopsOnRouteView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct StopsOnRouteView: View {
    var route: PTV.Models.Route
    @ObservedObject var model: StopsOnRoute
    
    init(route: PTV.Models.Route, stops: StopsOnRoute? = nil) {
        self.route = route
        self.model = stops ?? StopsOnRoute(route: route)
    }
    
    var body: some View {
        VStack {
            TransportIconView(type: route.transportType, size: .large)
            HStack {
                Text("Status:").bold()
                Text(route.routeServiceStatus.description)
            }
            List(model.stops) { stop in
                NavigationLink(destination: DeparturesView(stop: stop, route: self.route)) {
                    Text("\(stop.stopName)")
                }
            }
        }
        .navigationTitle(route.routeName)
        .task { await model.bind() }
    }
}

struct RouteView_Preview: PreviewProvider {
    static var previews: some View {
        StopsOnRouteView(route: .fixture, stops: .fixture)
    }
}

