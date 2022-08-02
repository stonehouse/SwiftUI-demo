//
//  PTVAsyncAPIAdapter.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 21/7/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation
import os

actor PTVAsyncAPIAdapter: DataAdapter {
    static let `default`: PTVAsyncAPIAdapter = {
        let token = PTVAccessToken(key: "27df7af0-a2e8-4dc9-805e-755035b5492d", developerID: 3001313)
        return PTVAsyncAPIAdapter(token: token, cache: true, debug: true)
    }()
    
    let token: PTVAccessToken
    let debug: Bool
    let decoder: JSONDecoder
    let logger = Logger(subsystem: "PTVAsyncAPIAdapter", category: "PTV")
    
    init(token: PTVAccessToken, cache: Bool, debug: Bool) {
        self.token = token
        self.cache = PTVCache(enabled: cache)
        self.debug = debug
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    private let cache: PTVCache
    
    func request<T: Endpoint>(endpoint: T) async throws -> T.ResultType  {
        guard let url = endpoint.prepareURL(using: token) else {
            logger.warning("Error signing route \(endpoint.path)")
            throw PTV.Errors.other
        }
        
        if let cached = await cache.retrieveCache(for: url), let decoded = try? self.decoder.decode(T.ResultType.self, from: cached) {
            logger.debug("Loading from cache...")
            
            return decoded
        }
        
        do {
            let result = try await URLSession.shared.data(from: url)
            logger.debug("Result from '\(url.absoluteString)': \(String(data: result.0, encoding: .utf8) ?? "empty")")
            let decoded = try self.decoder.decode(T.ResultType.self, from: result.0)
            if endpoint.cache {
                await cache.setCache(data: result.0, for: url)
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
