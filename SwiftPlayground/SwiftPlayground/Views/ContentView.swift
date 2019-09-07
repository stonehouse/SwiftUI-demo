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
            RouteTypesView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
