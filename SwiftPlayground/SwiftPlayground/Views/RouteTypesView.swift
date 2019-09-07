//
//  RouteTypesView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct RouteTypesView: View {
    @ObservedObject var model = RouteTypes()
    
    var body: some View {
        List(model.routeTypes) { routeType in
            NavigationLink(destination: RoutesView(routeTypes: [routeType]).navigationBarTitle(routeType.routeTypeName)) {
                Text(routeType.routeTypeName)
            }
        }.navigationBarTitle("PTV Services")
    }
}
