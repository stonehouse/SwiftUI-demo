//
//  PTVAsyncAPIAdapter.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 21/7/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation
import CommonCrypto
import Combine

actor PTVAsyncAPIAdapter: DataAdapter {
    struct AccessToken {
        let key: String
        let developerID: Int
    }
    
    static let `default`: PTVAsyncAPIAdapter = {
        let token = AccessToken( key: "27df7af0-a2e8-4dc9-805e-755035b5492d", developerID: 3001313)
        return PTVAsyncAPIAdapter(token: token, cache: true, debug: true)
    }()
    
    let token: AccessToken
    let debug: Bool
    let decoder: JSONDecoder
    
    init(token: AccessToken, cache: Bool, debug: Bool) {
        self.token = token
        self.useCache = cache
        self.debug = debug
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    let useCache: Bool
    private var cache: [URL: Data] = [:]
    
    private func prepare<T: Endpoint>(route: T) -> URL? {
        guard let url = route.url(token.developerID) else {
            return nil
        }
        
        if debug {
            print("Signing URL: \(url)")
        }
        guard let keyData = token.key.data(using: .ascii), let urlData = url.data(using: .ascii) else {
            return nil
        }
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
        defer { hashBytes.deallocate() }
        
        urlData.withUnsafeBytes { (ptr) -> Void in
            keyData.withUnsafeBytes { (keyPtr) -> Void in
                CCHmac(algorithm, keyPtr, keyData.count, ptr, urlData.count, hashBytes)
            }
        }
        let hmac = Data(bytes: hashBytes, count: digestLength)
        
        guard let signed = URL(string: String(format: "%@%@&signature=%@", PTV.API.baseURL, url, hmac.hexEncodedString(options: .upperCase))) else {
            return nil
        }
        
        return signed
    }
    
    func request<T: Endpoint>(endpoint: T) async throws -> T.ResultType  {
        guard let url = prepare(route: endpoint) else {
            print("Error signing route")
            throw PTV.Errors.other
        }
        
        if let cached = cache[url], let decoded = try? self.decoder.decode(T.ResultType.self, from: cached) {
            if debug {
                print("Loading from cache...")
            }
            
            return decoded
        }
        
        do {
            let result = try await URLSession.shared.data(from: url)
            if self.debug {
                print("Result from '\(url.absoluteString)': \(String(data: result.0, encoding: .utf8) ?? "empty")")
            }
            let decoded = try self.decoder.decode(T.ResultType.self, from: result.0)
            if self.useCache && endpoint.cache {
                // Only cache if we parsed the data
                self.cache[url] = result.0
            }
            return decoded
        } catch let error {
            switch error {
            case let e as URLError:
                throw PTV.Errors.network(e)
            default:
                throw PTV.Errors.encoding(error)
            }
        }
    }
}
