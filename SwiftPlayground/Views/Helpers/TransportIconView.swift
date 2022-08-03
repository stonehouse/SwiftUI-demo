//
//  TransportIconView.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 3/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import SwiftUI

struct TransportIconView: View {
    enum Size {
        case small, large
    }
    
    let type: TransportTypes
    var size: Size = .small
    
    var body: some View {
        switch type {
        case .train:
            Text("🚈").font(for: size)
        case .tram:
            Text("🚃").font(for: size)
        case .bus:
            Text("🚌").font(for: size)
        case .vline:
            Text("🚂").font(for: size)
        case .nightbus:
            Text("😴").font(for: size)
        }
    }
}

private extension Text {
    func font(for size: TransportIconView.Size) -> some View {
        switch size {
        case .small:
            return self
        case .large:
            return font(.largeTitle)
        }
    }
}
