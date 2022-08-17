//
//  Task+sleep.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 17/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(interval: DispatchTimeInterval) async throws {
        let duration: UInt64
        switch interval {
        case .seconds(let seconds):
            duration = UInt64(seconds * 1_000_000_000)
        case .milliseconds(let milliseconds):
            duration = UInt64(milliseconds * 1_000_000)
        case .microseconds(let microseconds):
            duration = UInt64(microseconds * 1_000)
        case .nanoseconds(let nanoseconds):
            duration = UInt64(nanoseconds)
        case .never:
            duration = UInt64.max
        @unknown default:
            fatalError("Unknown DispatchTimeInterval type '\(interval)'")
        }
        
        try await Task.sleep(nanoseconds: duration)
    }
}
