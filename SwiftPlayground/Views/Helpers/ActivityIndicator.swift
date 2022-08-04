//
//  ActivityIndicator.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 4/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
    	let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
    }
}
