//
//  SearchView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 24/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var model: Search = Search()
    
    var body: some View {
        List {
            ForEach(self.model.routes) { result in
                NavigationLink(destination: RouteView(route: result), label: {
                    Text("\(result.routeName)")
                })
            }
        }
        .searchable(text: $model.searchTerm)
        .navigationTitle("Search")
        .task { await model.bind() }
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(model: .fixture)
    }
}
