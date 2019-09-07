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
private let encoder = JSONEncoder()

protocol Routable {
    associatedtype ResultType: Codable
    
    var path: String { get }
    var query: [String: String] { get }
    func url(_ token: PTV.AccessToken) -> String?
}

extension Routable {
    func url(_ token: PTV.AccessToken) -> String? {
        var components = URLComponents()
        components.path = "/v\(apiVersion)/\(path)"
        components.queryItems = query.compactMap {
            return URLQueryItem(name: $0.key, value: $0.value)
        }
        components.queryItems?.append(URLQueryItem(name: "devid", value: "\(token.developerID)"))
        
        return components.string
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
    
    private func prepare<T: Routable>(route: T, token: AccessToken) -> URL? {
        guard let url = route.url(token) else {
            return nil
        }
        
        print("Signing URL: \(url)")
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
        
        guard let signed = URL(string: String(format: "%@%@&signature=%@", baseURL, url, hmac.hexEncodedString(options: .upperCase))) else {
            return nil
        }
        return signed
    }
    
    enum Errors: Error {
        case network(URLError)
        case deserializing(Error)
    }
    
    func request<T: Routable>(route: T) -> AnyPublisher<T.ResultType, URLError>  {
        guard let url = prepare(route: route, token: token) else {
            print("Error signing route")
            return AnyPublisher(Empty())
        }
        return AnyPublisher(URLSession.shared.dataTaskPublisher(for: url)
                    .compactMap {
                        try? self.decoder.decode(T.ResultType.self, from: $0.data)
                    })
    }
    
    func requestRaw<T: Routable>(route: T) -> AnyPublisher<String, URLError>  {
        guard let url = prepare(route: route, token: token) else {
            print("Error signing route")
            return AnyPublisher(Empty())
        }
        return AnyPublisher(URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { String(data: $0.data, encoding: .utf8) })
    }
}
