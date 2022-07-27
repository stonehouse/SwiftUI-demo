//
//  SearchView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 24/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State var searchTerm: String = ""
    @ObservedObject var model: Search
    
    init(model: Search = Search()) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchTerm, onEditingChanged: { _ in }, onCommit: {
                        self.model.update(search: self.searchTerm)
                    })
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
            .background(Color(.secondarySystemFill))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray, lineWidth: 2))
            .padding(.horizontal, 10)
            List {
                 ForEach(self.model.routes) { result in
                     NavigationLink(destination: RouteView(route: result), label: {
                         Text("\(result.routeName)")
                     })
                 }
            }
        }
        .task { await model.bind() }
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(model: .fixture)
    }
}
