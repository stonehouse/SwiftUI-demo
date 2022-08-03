//
//  DeparturesView.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct DeparturesView: View {
    @ObservedObject var model: Departures
    
    init(stop: PTV.Models.Stop, route: PTV.Models.Route? = nil) {
        self.model = Departures(stop: stop, route: route)
    }
    
    init(model: Departures) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text("\(model.stop.stopName)").font(.title)
            List(model.departuresSoon) { info in
                VStack {
                    HStack {
                        Text("\(info.direction) ").bold()
                        Spacer()
                        Text(info.platform).foregroundColor(.gray)
                    }
                    HStack {
                        Text("Departing in \(info.time)")
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitle("Departures")
        .task { await model.bind() }
    }
}

struct DeparturesView_Preview: PreviewProvider {
    static var previews: some View {
        DeparturesView(model: .fixture)
    }
}
