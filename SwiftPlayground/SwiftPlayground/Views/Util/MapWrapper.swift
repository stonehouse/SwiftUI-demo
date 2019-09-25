//
//  MapWrapper.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 25/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine
import MapKit

class MapWrapper: UIView {
    let mapView = MKMapView(frame: .zero)
    let location = LocationAccessManager()
    var cancellable: Cancellable?
    
    init() {
        super.init(frame: .zero)
        cancellable = location.publisher.sink(receiveCompletion: { _ in }, receiveValue: { value in
            print("ZZZ \(value)")
        })
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(mapView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = bounds
    }
}
