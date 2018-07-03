//
//  main.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

//MARK:- Common functions
func returnSelectedCategory(forInstance instance: Storagable) -> Categories? {
    print("Type 'all' or a category from the list below:")
   
    for item in instance.items.keys {
        print("\(item.category.rawValue)")
    }
    
    let inp = getln()
    guard let currentCategory = Categories(rawValue: inp) else {
        print("No such category")
        return nil
    }
    return currentCategory
}

func splitSpecificInput(byCharSet string: String, withMessage message: String) -> [String] {
    print(message)
    let inp = getln()
    let charSet = CharacterSet.init(charactersIn: string)
    return inp.components(separatedBy: charSet)
}



print("Hello, World!")

var shop = Shop()
shop.balance = [
    "Cash" : 500,
    "Card" : 400,
    "Bitcoin": 10
]
shop.items = [
    Good(name: "apple", price: 20, category: Categories.food) : 2,
    Good(name: "t-shirt", price: 30, category: Categories.cloth) : 3,
    Good(name: "aspirine", price: 10, category: Categories.medicine) : 5
]

let bank = Bank()

// MARK: - Begin
print("Welcome to the shop. What's your name?")

let name = getln()
// Client instance
var client = Client(name: name)

// Setting delegates
shop.delegate = client.cart
client.cart.delegate = shop

// Set balance
for payMethod in Payment.cases {
    var input: Double?
    
    repeat {
        print("\(client.name), your balance in \(payMethod.rawValue) is ")
        input = Double(getln())
    } while input == nil
    
    client.balance.updateValue(input!, forKey: payMethod.rawValue)
}

// Choose current payment method
var currentPayMethod: Payment?

repeat {
    print("Now choose current payment type: cash, card, bitcoin")
    let inp = getln()
    currentPayMethod = Payment(rawValue: inp)
} while currentPayMethod == nil

// MARK: -Main cycle
while true {
    print("list of available commands: cart, assortiment, checkout (ca | as | ch)")
    let command = getln().lowercased()
    
    switch command {
    case "ca":
        if client.cart.items.isEmpty { print("it's empty") } else {
            
            guard let currentCategory = returnSelectedCategory(forInstance: client.cart) else {
                print("there is no such category")
                continue
            }
            
            client.cart.showItems(forCategory: currentCategory)
            if didAgree(toQuestion: "remove some items?") {
                
                let inputs = splitSpecificInput(byCharSet: " .,", withMessage: "write item's name and quantity separated by comma, dot or white-space")
                let name = inputs[0]
                guard let quantity = Int(inputs[1]) else {
                    print("Invalid format")
                    continue
                }
                
                shop.addItems(named: name, inAmountOf: quantity, withCompletionHandler: { (success) in
                    if success {
                        client.cart.removeItems(named: name, inAmountOf: quantity)
                    }
                })
            }
        }
    case "as":
        if shop.items.isEmpty { print("it's empty") } else {
            
            guard let currentCategory = returnSelectedCategory(forInstance: shop) else {
                print("there is no such category")
                continue
            }
            
            shop.showItems(forCategory: currentCategory)
            if didAgree(toQuestion: "add items to cart?") {
                
                var sum = 0
                for (_, quantity) in client.cart.items {
                    sum += quantity!
                }
                if sum >= 10 {
                    print("Your cart is full, remove some items")
                    continue
                }
                
                let inputs = splitSpecificInput(byCharSet: " .,", withMessage: "write item's name and quantity separated by comma, dot or white-space")
                
                let name = inputs[0]
                guard let quantity = Int(inputs[1]) else {
                    print("Invalid format")
                    continue
                }
                
                client.cart.addItems(named: name, inAmountOf: quantity, withCompletionHandler: { (success: Bool) in
                    print("completion in ction")
                    if success {
                        print("about to remove some items from the shop")
                        shop.removeItems(named: name, inAmountOf: quantity)
                    }
                })
            }
        }
    case "ch":
        let capacity = bank.canPay(giver: client, currency: currentPayMethod!)
        switch capacity {
        case .success:
            bank.executeTransaction(from: &client, to: &shop)
            client.balance.forEach({ (key, balance) in
                print("Now you have \(balance) in \(key)")
            })
            shop.balance.forEach({ (key, balance) in
                print("Now we have \(balance) in \(key)")
            })
            
            client.cart.items.removeAll()
        case .failure(let message):
            print(message)
        }
    default:
        continue
    }
}
