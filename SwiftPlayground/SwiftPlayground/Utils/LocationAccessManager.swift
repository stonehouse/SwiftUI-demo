//
//  LocationAccessManager.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 25/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class LocationAccessManager: NSObject, CLLocationManagerDelegate {
    enum Event {
        case authorized, denied, location(CLLocation)
    }
    
    private let locationManager = CLLocationManager()
    private let subject = PassthroughSubject<Event, Error>()
    
    var publisher: AnyPublisher<Event, Error> {
        AnyPublisher(subject.first().handleEvents(receiveSubscription: { [unowned self] _ in
            self.check()
        }))
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    private func check() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            subject.send(.denied)
        case .authorizedAlways, .authorizedWhenInUse:
            subject.send(.authorized)
        @unknown default:
            print("Unknown permission value")
        }
    }
    
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            subject.send(.authorized)
        case .notDetermined: break
        default:
            subject.send(.denied)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            subject.send(.location(location))
        }
    }
}
