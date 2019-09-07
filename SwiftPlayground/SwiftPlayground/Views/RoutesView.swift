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
        self.model = Routes(routeTypes: routeTypes)
    }
    
    var body: some View {
        List(model.routes) { route in
            NavigationLink(destination: RouteView(route: route)) {
                Text(route.routeName)
            }
        }
    }
}
