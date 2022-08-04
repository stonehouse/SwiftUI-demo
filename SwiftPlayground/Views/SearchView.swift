//
//  SearchView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 24/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @StateObject var model: Search = Search()
    
    var body: some View {
        LoadingView(loading: $model.loading, {
            List {
                ForEach(self.model.results) { result in
                    NavigationLink(destination: result.destination, label: {
                        switch result {
                        case .stop(let stop):
                            Text("🛑 \(stop.stopName)")
                        case .route(let route):
                            HStack {
                                TransportIconView(type: route.transportType)
                                Text("\(route.routeName)")
                            }
                        }
                    })
                }
            }
        })
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
            StopsOnRouteView(route: route)
        }
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(model: .fixture)
    }
}
