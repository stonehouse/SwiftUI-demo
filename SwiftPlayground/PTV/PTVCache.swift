//
//  PTVCache.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 2/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation

actor PTVCache {
    private var cache: [URL: any RootResultType] = [:]
    private let enabled: Bool
    
    init(enabled: Bool) {
        self.enabled = enabled
    }
    
    func setCache(result: some RootResultType, for url: URL) {
        guard enabled else { return }
        cache[url] = result
    }
    
    func retrieveCache(for url: URL) -> (any RootResultType)? {
        return cache[url]
    }
}
