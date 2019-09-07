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
    var departures: [Departures.Model] {
        model.departures.sorted(by: {
            $0.departureSequence < $1.departureSequence
        })
    }
    
    init(stop: PTV.Models.Stop, route: PTV.Models.Route) {
        self.model = Departures(stop: stop, route: route)
    }
    
    init(model: Departures) {
        self.model = model
    }
    
    var body: some View {
        List(departures) { departure in
            VStack {
                Text("Platform \(departure.platformNumber) Direction \(departure.directionId)")
                Text("\(departure.scheduledDepartureUtc)")
            }
        }.onAppear(perform: appear)
    }
    
    func appear() {
        model.load()
    }
}

struct DeparturesView_Preview: PreviewProvider {
    static var previews: some View {
        DeparturesView(model: .fixture)
    }
}
