//
//  Endpoint+prepareURL.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 2/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation
import CommonCrypto

extension Endpoint {
    func prepareURL(using token: PTVAccessToken) -> URL? {
        guard let url = self.url(token.developerID),
              let signature = url.sign(with: token.key),
              let signed = URL(string: String(format: "%@%@&signature=%@", PTV.API.baseURL, url, signature)) else {
            return nil
        }
        
        return signed
    }
}

private extension String {
    func sign(with key: String) -> String? {
        guard let keyData = key.data(using: .ascii), let urlData = data(using: .ascii) else {
            return nil
        }
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
        defer { hashBytes.deallocate() }
        
        urlData.withUnsafeBytes { ptr -> Void in
            keyData.withUnsafeBytes { keyPtr -> Void in
                CCHmac(algorithm, keyPtr.baseAddress, keyData.count, ptr.baseAddress, urlData.count, hashBytes)
            }
        }
        let hmac = Data(bytes: hashBytes, count: digestLength)
        return hmac.hexEncodedString(options: .upperCase)
    }
}
