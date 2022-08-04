//
//  ViewModel.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 21/7/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation

protocol ViewModel: ObservableObject {
    func bind() async
}
