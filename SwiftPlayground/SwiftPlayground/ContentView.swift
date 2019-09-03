//
//  ContentView.swift
//  SwiftPlayground
//
//  Created by alex on 3/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI
import Combine

let token = PTV.AccessToken(
    key: "27df7af0-a2e8-4dc9-805e-755035b5492d",
    developerID: 3001313)
let ptv = PTV(token: token)
var cancellable: AnyCancellable?

struct ContentView: View {
    
    @State var routes: String = "..."
    
    var body: some View {
        VStack {
            Text("Swift UI 🥳")
            Text(routes)
        }.onAppear(perform: fetch)
    }
    
    func fetch() {
        cancellable = ptv.request(route: .routeTypes)
        .sink(receiveCompletion: { err in
            print("Completion: \(String(describing: err))")
        }, receiveValue: { value in
            self.routes = value
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
