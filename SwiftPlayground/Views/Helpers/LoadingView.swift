//
//  LoadingView.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 4/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import SwiftUI

struct LoadingView<Content: View>: View {
    let content: Content
    
    @Binding var loading: Bool
    
    init(loading: Binding<Bool>, @ViewBuilder _ content: () -> Content) {
        self.content = content()
        self._loading = loading
    }
    
    var body: some View {
        ZStack {
            content
            if loading {
                ActivityIndicator()
            }
        }
    }
}
