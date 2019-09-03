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

class PTV {
    let baseURL = "https://timetableapi.ptv.vic.gov.au"
    enum Routes: String {
        case routeTypes = "/v3/route_types"
    }
    
    struct AccessToken {
        let key: String
        let developerID: Int
    }
    
    let token: AccessToken
    
    init(token: AccessToken) {
        self.token = token
    }
    
    private func prepare(route: Routes, token: AccessToken) -> URL? {
        let path = route.rawValue
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
    
    func request(route: Routes) -> AnyPublisher<String, URLError>  {
        guard let url = prepare(route: route, token: token) else {
            print("Error signing route")
            return AnyPublisher(Empty())
        }
        return AnyPublisher(URLSession.shared.dataTaskPublisher(for: url).compactMap {
            String(data: $0.data, encoding: .utf8)
        })
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
