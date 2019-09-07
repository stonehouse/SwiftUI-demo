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
    
    init(route: PTV.Models.Route) {
        self.model = route
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Status:").bold()
                Text(model.routeServiceStatus.description)
            }
            Spacer()
            NavigationLink(destination: StopsOnRouteView(route: model)) {
                Text("View Stops")
            }
        }.navigationBarTitle(model.routeName)
    }
}
