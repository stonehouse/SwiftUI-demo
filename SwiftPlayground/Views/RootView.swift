//
//  ContentView.swift
//  SwiftPlayground
//
//  Created by alex on 3/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI
import Combine

struct RootView: View {
    var body: some View {
        NavigationView {
            RouteTypesView()
                .navigationBarTitle("PTV SwiftUI 🥳")
                .navigationBarItems(trailing:
            NavigationLink(destination: SearchView(), label: { Image(systemName: "magnifyingglass") }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
