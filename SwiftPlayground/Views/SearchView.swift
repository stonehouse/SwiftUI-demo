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
            ForEach(self.model.results) { result in
                NavigationLink(destination: result.destination, label: {
                    Text("\(result.name)")
                })
            }
        }
        .searchable(text: $model.searchTerm)
        .navigationTitle("Search")
        .task { await model.bind() }
    }
}

extension Search.Result {
    @ViewBuilder
    var destination: some View {
        switch self {
        case .stop(let stop):
            DeparturesView(stop: stop)
        case .route(let route):
            RouteView(route: route)
        }
    }
    
    var name: String {
        switch self {
        case .stop(let stop):
            return stop.stopName
        case .route(let route):
            return route.routeName
        }
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(model: .fixture)
    }
}
