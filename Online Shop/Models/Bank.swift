//
//  Bank.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

protocol Payable {
    var balance: [String: Double] { get set }
}

class Bank {
    var sum: Double = 0.0
    
    let bitcoinCoef: Double = 0.00001
    var multiplier: Double = 1.0
    let cardCoef: Double = 0.8
    var currency: Payment?
    var balance: Double = 0.0
    // Credibility
    func canPay(giver: Payable, currency: Payment) -> TransState {
        
        self.currency = currency
        multiplier = convert(currency: currency)
        
        if let giver = giver as? Client {
            giver.cart.items.keys.forEach { (good) in
                sum = sum + good.price
            }
        } else if let giver = giver as? Shop {
            giver.items.keys.forEach({ (good) in
                sum = sum + good.price
            })
        }
        
        if let balance = giver.balance[currency.rawValue] {
            self.balance = balance
            if sum * multiplier <= balance {  return TransState.success } else { return TransState.failure("Not enough money") }
        } else { return TransState.failure("No balance at all") }
    }
    // Execute
    func executeTransaction(from giver: inout Client,to receiver: inout Shop) {
        self.balance = self.balance - sum * multiplier
        giver.balance[currency!.rawValue] = self.balance
        receiver.balance[currency!.rawValue] = self.balance + 2 * sum * multiplier
    }
    
    internal func convert(currency: Payment) -> Double {
        
        switch currency {
        case .bitcoin:
            return bitcoinCoef
        case .cash:
            return 1
        case .card:
            return cardCoef
        }
    }
}
