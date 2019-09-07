//
//  DataAdapter.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import CommonCrypto
import Combine

class PTVAPIAdapter: DataAdapter {
    static let `default`: DataAdapter = {
        let token = AccessToken( key: "27df7af0-a2e8-4dc9-805e-755035b5492d", developerID: 3001313)
        return PTVAPIAdapter(token: token, debug: false)
    }()
    
    struct AccessToken {
        let key: String
        let developerID: Int
    }
    
    let token: AccessToken
    let debug: Bool
    let decoder: JSONDecoder
    
    init(token: AccessToken, debug: Bool) {
        self.token = token
        self.debug = debug
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
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
    
    func request<T: Endpoint>(route: T) -> AnyPublisher<T.ResultType, PTV.Errors>  {
        guard let url = prepare(route: route) else {
            print("Error signing route")
            return AnyPublisher(Empty())
        }
        return AnyPublisher(URLSession.shared.dataTaskPublisher(for: url)
                    .mapError({ PTV.Errors.network($0) })
                    .compactMap {
                        if self.debug {
                            print("Result from '\(url.absoluteString)': \(String(data: $0.data, encoding: .utf8) ?? "empty")")
                        }
                        return try? self.decoder.decode(T.ResultType.self, from: $0.data)
                    })
    }
}
