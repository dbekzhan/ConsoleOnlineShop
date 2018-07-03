//
//  Client.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

class Client: Payable {
    var name: String
    var balance: [String: Double]
    var cart: Cart
    
    
    init(name: String, balance: [String: Double], cart: Cart) {
        self.name = name
        self.balance = balance
        self.cart = cart
    }
    
    convenience init(name: String) {
        self.init(name: name, balance: [:], cart: Cart())
    }
}

