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
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: RouteTypesView(), label: {
                    Text("Service Types")
                }).padding(50)
                NavigationLink(destination: StopsNearMeView(), label: {
                    Text("Stops Near Me")
                }).padding(50)
            }
            .navigationBarTitle("PTV SwiftUI 🥳")
            .navigationBarItems(trailing:
            NavigationLink(destination: SearchView(), label: { Image(systemName: "magnifyingglass") }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
