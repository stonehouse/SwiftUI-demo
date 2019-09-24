//
//  StopsNearMeView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 25/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct StopsNearMeView: View {
    
    var body: some View {
        MapView().onAppear(perform: appear)
    }
    
    func appear() {
        
    }
}
