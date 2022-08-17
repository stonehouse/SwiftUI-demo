//
//  AsyncMap.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 17/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation

extension Collection {
    func asyncMap<T>(_ mapper: @escaping (Element) async throws -> T) async throws -> [T] {
        return try await withThrowingTaskGroup(of: T.self, body: { group in
            var results: [T] = []
            
            for element in self {
                group.addTask {
                    try await mapper(element)
                }
            }
            
            for try await result in group {
                results.append(result)
            }
            
            return results
        })
    }
}
