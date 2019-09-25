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
    
    func direction(for departure: PTV.Models.Departure) -> PTV.Models.Direction? {
        model.directions.first(where: { $0.directionId == departure.directionId })
    }
    
    init(stop: PTV.Models.Stop, route: PTV.Models.Route, directions: [PTV.Models.Direction]) {
        self.model = Departures(stop: stop, route: route, directions: directions)
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
                        Text("\(self.direction(for: info.departure)?.directionName ?? "") ").bold()
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
        .navigationBarTitle("Departures").onAppear(perform: appear)
    }
    
    func appear() {
        if model.departures.count == 0 {
            model.load()
        }
    }
}

struct DeparturesView_Preview: PreviewProvider {
    static var previews: some View {
        DeparturesView(model: .fixture)
    }
}
