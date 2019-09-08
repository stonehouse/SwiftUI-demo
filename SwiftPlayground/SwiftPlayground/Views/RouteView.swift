//
//  RouteView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct RouteView: View {
    var model: PTV.Models.Route
    @ObservedObject var stops: StopsOnRoute
    
    init(route: PTV.Models.Route, stops: StopsOnRoute? = nil) {
        self.model = route
        self.stops = stops ?? StopsOnRoute(route: route)
    }
    
    var body: some View {
        VStack {
            Text("\(model.routeName)").font(.title)
            HStack {
                Text("Status:").bold()
                Text(model.routeServiceStatus.description)
            }
            List(stops.stops) { stop in
                NavigationLink(destination: DeparturesView(stop: stop, route: self.model, directions: self.stops.directions)) {
                    Text("\(stop.stopName)")
                }
            }
        }.onAppear(perform: appear)
    }
    
    func appear() {
        stops.load()
    }
}

struct RouteView_Preview: PreviewProvider {
    static var previews: some View {
        RouteView(route: .fixture, stops: .fixture)
    }
}

