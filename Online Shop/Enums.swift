//
//  Protocols.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ success: Bool) -> Void

enum TransState {
    case success, failure(String)
}

enum Payment: String {
    case cash, card, bitcoin
    static let cases = [cash, card, bitcoin]
}

enum Categories: String {
    case food, cloth, medicine, all
}


