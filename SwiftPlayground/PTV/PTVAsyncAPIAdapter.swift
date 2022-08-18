//
//  PTVAsyncAPIAdapter.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 21/7/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation
import os

class PTVAsyncAPIAdapter: DataAdapter {
    static let `default`: PTVAsyncAPIAdapter = {
        let token = PTVAccessToken(key: "27df7af0-a2e8-4dc9-805e-755035b5492d", developerID: 3001313)
        return PTVAsyncAPIAdapter(token: token, cache: true)
    }()
    
    let token: PTVAccessToken
    let decoder: JSONDecoder
    let logger = Logger(subsystem: "PTVAsyncAPIAdapter", category: "PTV")
    private let cache: PTVCache
    
    init(token: PTVAccessToken, cache: Bool) {
        self.token = token
        self.cache = PTVCache(enabled: cache)
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T: Endpoint>(endpoint: T) async throws -> T.ResultType  {
        guard let url = endpoint.prepareURL(using: token) else {
            logger.warning("Error signing route \(endpoint.path)")
            throw PTV.Errors.other
        }
        
        if endpoint.cache, let cached = await cache.retrieveCache(for: url), let decoded = cached as? T.ResultType {
            logger.debug("Loading \(endpoint.path) from cache...")
            return decoded
        }
        
        do {
            let result = try await URLSession.shared.data(from: url)
            let decoded = try self.decoder.decode(T.ResultType.self, from: result.0)
            logger.debug("Request to \(url.path()) was successful")
            if endpoint.cache {
                await cache.setCache(result: decoded, for: url)
            }
            return decoded
        } catch let error {
            logger.error("Error loading result from \(url)")
            switch error {
            case let e as URLError:
                throw PTV.Errors.network(e)
            default:
                throw PTV.Errors.encoding(error)
            }
        }
    }
}
