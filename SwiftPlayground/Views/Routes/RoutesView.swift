//
//  RoutesView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct RoutesView: View {
    @ObservedObject var model: Routes
    
    init(routeTypes: [PTV.Models.RouteType]) {
        self.init(model: Routes(routeTypes: routeTypes))
    }
    
    init(model: Routes) {
        self.model = model
    }
    
    var body: some View {
        List(model.routes) { route in
            NavigationLink(destination: StopsOnRouteView(route: route)) {
                Text(route.routeName)
            }
        }
        .task { await model.bind() }
    }
}

struct RoutesView_Preview: PreviewProvider {
    static var previews: some View {
        RoutesView(model: .fixture)
    }
}

