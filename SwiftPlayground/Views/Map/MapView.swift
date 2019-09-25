//
//  MapView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 25/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MapWrapper {
        MapWrapper()
    }

    func updateUIView(_ view: MapWrapper, context: Context) {
        view.mapView.showsUserLocation = true
    }
    
    func setRegion(_ view: MapWrapper, latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.mapView.setRegion(region, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
