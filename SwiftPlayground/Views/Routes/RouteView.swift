//
//  RouteView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct RouteView: View {
    var route: PTV.Models.Route
    @ObservedObject var model: StopsOnRoute
    
    init(route: PTV.Models.Route, stops: StopsOnRoute? = nil) {
        self.route = route
        self.model = stops ?? StopsOnRoute(route: route)
    }
    
    var body: some View {
        VStack {
            Text("\(route.routeName)").font(.title)
            HStack {
                Text("Status:").bold()
                Text(route.routeServiceStatus.description)
            }
            List(model.stops) { stop in
                NavigationLink(destination: DeparturesView(stop: stop, route: self.route, directions: self.model.directions)) {
                    Text("\(stop.stopName)")
                }
            }
        }
        .task { await model.bind() }
    }
}

struct RouteView_Preview: PreviewProvider {
    static var previews: some View {
        RouteView(route: .fixture, stops: .fixture)
    }
}

