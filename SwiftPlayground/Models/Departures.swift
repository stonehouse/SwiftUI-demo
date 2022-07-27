//
//  Departures.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine


class Departures: ViewModel {
    typealias Model = PTV.Models.Departure
    
    struct DepartureInfo: Identifiable {
        typealias ID = Date
        var id: ID {
            departure.scheduledDepartureUtc
        }
        let departure: Model
        let time: String
        var platform: String {
            if let platform = departure.platformNumber {
                return "Platform \(platform)"
            }
            return ""
        }
    }
    
    let formatter: DateFormatter
    let endpoint: PTV.API.DeparturesAtStop
    var cancellables: [AnyCancellable] = []
    let stop: PTV.Models.Stop
    let route: PTV.Models.Route
    let directions: [PTV.Models.Direction]
    let now: Date
    let filterOld: Bool
    @Published var departures: [Model] = []
    var departuresSoon: [DepartureInfo] {
        departures.compactMap {
            let distance = ($0.estimatedDepartureUtc ?? $0.scheduledDepartureUtc).distance(to: now)
            guard !filterOld || distance > 0 else {
                return nil
            }
            
            return DepartureInfo(departure: $0, time: distance.string)
        }
    }

    init(stop: PTV.Models.Stop, route: PTV.Models.Route, directions: [PTV.Models.Direction], now: Date = Date(), filterOld: Bool = true) {
        self.stop = stop
        self.route = route
        self.directions = directions
        self.now = now
        self.filterOld = filterOld
        self.endpoint = PTV.API.DeparturesAtStop(stop: stop, route: route)
        self.formatter = DateFormatter()
    }
    
    @MainActor
    func bind() async {
        do {
            let result = try await ptv.request(endpoint: endpoint)
            self.departures = result.departures.sorted(by: { $0.id > $1.id })
        } catch _ {
            
        }
    }
}

private let secondsInMinute: TimeInterval = 60
private let secondsInHour = secondsInMinute * 60

extension TimeInterval {
    var string: String {
        var time = self
        var str = ""
        let hours = floor(time / secondsInHour)
        
        if hours >= 1 {
            time -= hours * secondsInHour
            str += "\(Int(hours)) hours"
        }
        
        let minutes = floor(time / secondsInMinute)
        if minutes >= 1 {
            time -= minutes * secondsInMinute
            if hours >= 1 {
                str += ", "
            }
            str += "\(Int(minutes)) minutes"
        }
        
        let seconds = floor(time)
        if seconds > 0 {
            if str.count > 0 {
                str += ", "
            }
            str += "\(Int(time)) seconds"
        }
        
        return str
    }
}
