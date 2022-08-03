//
//  TransportIconView.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 3/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import SwiftUI

struct TransportIconView: View {
    let type: TransportTypes
    
    var body: some View {
        switch type {
        case .train:
            Text("🚈")
        case .tram:
            Text("🚃")
        case .bus:
            Text("🚌")
        case .vline:
            Text("🚂")
        case .nightbus:
            Text("😴")
        }
    }
}
