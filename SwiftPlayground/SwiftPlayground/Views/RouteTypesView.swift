//
//  RouteTypesView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct RouteTypesView: View {
    @ObservedObject var model: RouteTypes

    init(_ model: RouteTypes = RouteTypes()) {
        self.model = model
    }
    
    var body: some View {
        List(model.routeTypes) { routeType in
            NavigationLink(destination: RoutesView(routeTypes: [routeType]).navigationBarTitle(routeType.routeTypeName)) {
                Text(routeType.routeTypeName)
            }
        }.navigationBarTitle("PTV Services")
        .onAppear(perform: appear)
    }
    
    func appear() {
        model.load()
    }
}

struct RouteTypesView_Preview: PreviewProvider {
    static var previews: some View {
        RouteTypesView(.fixture)
    }
}
