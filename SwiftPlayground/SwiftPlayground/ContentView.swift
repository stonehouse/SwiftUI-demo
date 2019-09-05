//
//  ContentView.swift
//  SwiftPlayground
//
//  Created by alex on 3/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var types = RouteTypes()
    
    var body: some View {
        VStack {
            Text("Swift UI 🥳")
            ForEach(types.routeTypes) { routeType in
                Text("\(routeType.routeType) \(routeType.routeTypeName)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
