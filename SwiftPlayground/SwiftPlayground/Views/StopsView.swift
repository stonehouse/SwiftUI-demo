//
//  StopsView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct StopsOnRouteView: View {
    @ObservedObject var model: StopsOnRoute
    
    init(route: PTV.Models.Route) {
        self.model = StopsOnRoute(route: route)
    }
    
    init(model: StopsOnRoute) {
        self.model = model
    }
    
    var body: some View {
        List(model.stops) { stop in
            NavigationLink(destination: DeparturesView(stop: stop, route: self.model.route).navigationBarTitle("Departures from \(stop.stopName)")) {
                Text("\(stop.stopName)")
            }
        }.onAppear(perform: appear)
    }
    
    func appear() {
        model.load()
    }
}

struct StopsOnRouteView_Preview: PreviewProvider {
    static var previews: some View {
        StopsOnRouteView(model: .fixture)
    }
}

