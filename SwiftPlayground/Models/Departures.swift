//
//  Departures.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation

class Departures: ViewModel {
    typealias Model = PTV.Models.Departure
    
    struct DepartureInfo: Identifiable {
        typealias ID = Date
        var id: ID {
            departure.scheduledDepartureUtc
        }
        let departure: Model
        let time: String
        let direction: String
        var platform: String {
            if let platform = departure.platformNumber {
                return "Platform \(platform)"
            }
            return ""
        }
    }
    
    let stop: PTV.Models.Stop
    @Published var departures: [Model] = []
    @Published var loading = false
    
    private let formatter: DateFormatter
    private let routes: [PTV.Models.Route]
    var directions: [PTV.Models.Direction] = []
    private let now: Date
    private let filterOld: Bool
    
    var departuresSoon: [DepartureInfo] {
        departures.compactMap {
            let distance = ($0.estimatedDepartureUtc ?? $0.scheduledDepartureUtc).distance(to: now)
            guard !filterOld || (distance > 0 && distance < 3600) else {
                return nil
            }
            
            return DepartureInfo(departure: $0, time: distance.string, direction: direction(for: $0)?.directionName ?? "")
        }
    }

    init(stop: PTV.Models.Stop, route: PTV.Models.Route?, now: Date = Date(), filterOld: Bool = true) {
        self.stop = stop
        if let route = route {
            self.routes = [route]
        } else {
            self.routes = stop.routes ?? []
        }
        self.now = now
        self.filterOld = filterOld
        self.formatter = DateFormatter()
    }
    
    private func direction(for departure: PTV.Models.Departure) -> PTV.Models.Direction? {
        directions.first(where: { $0.directionId == departure.directionId })
    }
    
    @MainActor
    func bind() async {
        do {
            loading = true
            
            // Task group has to return an array of arrays because API can return multiple
            async let directions = routes.asyncMap { route in
                return try await ptv.request(endpoint: PTV.API.Directions(route: route)).directions
            }.flatMap { $0 }
            
            let endpoint: PTV.API.DeparturesAtStop
            if routes.count == 1 {
                endpoint = PTV.API.DeparturesAtStop(stop: stop, route: routes[0])
            } else {
                endpoint = PTV.API.DeparturesAtStop(stop: stop)
            }
            async let result = ptv.request(endpoint: endpoint)
            
            self.directions = try await directions
            self.departures = try await result.departures.sorted(by: { $0.id > $1.id })
            loading = false
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
