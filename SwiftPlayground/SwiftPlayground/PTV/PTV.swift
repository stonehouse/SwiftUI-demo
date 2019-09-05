//
//  PTV.swift
//  SwiftPlayground
//
//  Created by alex on 3/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import CommonCrypto
import Combine

private let baseURL = "https://timetableapi.ptv.vic.gov.au"
private let apiVersion = "3"

protocol Routable {
    associatedtype ResultType: Codable
    
    var component: String { get }
    var path: String { get }
    init()
}

extension Routable {
    var path: String {
        return "/v\(apiVersion)/\(component)"
    }
}

class PTV {
    static let routeTypes = API.RouteTypes()
    
    struct AccessToken {
        let key: String
        let developerID: Int
    }
    
    let token: AccessToken
    
    let decoder: JSONDecoder
    
    init(token: AccessToken) {
        self.token = token
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func prepare(path: String, token: AccessToken) -> URL? {
        let url = String(format: "%@%@devid=%d", path, path.contains("?") ? "&" : "?", token.developerID)
        
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
        
        return URL(string: String(format: "%@%@&signature=%@", baseURL, url, hmac.hexEncodedString(options: .upperCase)))
    }
    
    enum Errors: Error {
        case network(URLError)
        case deserializing(Error)
    }
    
    func request<T: Routable>(route: T) -> AnyPublisher<T.ResultType, URLError>  {
        guard let url = prepare(path: route.path, token: token) else {
            print("Error signing route")
            return AnyPublisher(Empty())
        }
        return AnyPublisher(URLSession.shared.dataTaskPublisher(for: url)
                    .compactMap {
                        try? self.decoder.decode(T.ResultType.self, from: $0.data)
                    })
    }
    
    func requestRaw<T: Routable>(route: T) -> AnyPublisher<String, URLError>  {
        guard let url = prepare(path: route.path, token: token) else {
            print("Error signing route")
            return AnyPublisher(Empty())
        }
        return AnyPublisher(URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { String(data: $0.data, encoding: .utf8) })
    }
}
