//
//  PTVCache.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 2/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation

actor PTVCache {
    private var cache: [URL: Data] = [:]
    private let enabled: Bool
    
    init(enabled: Bool) {
        self.enabled = enabled
    }
    
    func setCache(data: Data, for url: URL) {
        guard enabled else { return }
        cache[url] = data
    }
    
    func retrieveCache(for url: URL) -> Data? {
        return cache[url]
    }
}
