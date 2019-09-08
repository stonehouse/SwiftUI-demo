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
            List(departures) { departure in
                VStack {
                    Text("\(self.direction(for: departure)?.directionName ?? "\(departure.directionId)...") Platform \(departure.platformNumber ?? "9 3/4") ")
                    Text("\(departure.scheduledDepartureUtc)")
                }
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
