//
//  Storagable.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

protocol Storagable {
    var items: [Good : Int?] { get set }
    var delegate: Storagable? { get set }
    //
    func showItems(forCategory category: Categories)
    //
    mutating func removeItems(named name: String, inAmountOf number: Int)
    func accessItems(named name: String, inAmountOf number: Int) -> (Good?, TransState)
    mutating func addItems(named name: String, inAmountOf number: Int, withCompletionHandler comHandler: CompletionHandler)
}

extension Storagable {
    func showItems(forCategory category: Categories) {
        
        if category == .all {
            for (good, quantity) in items {
                print("\(good.name) in the number of \(quantity!)")
            }
        } else {
            let filteredItems = self.items.filter { (good, _) -> Bool in
                good.category == category
            }
            for (good, quantity) in filteredItems {
                print("\(good.name) in the number of \(quantity!)")
            }
        }
    }
    
    // returns item only if it's inside the storage and in sufficient quantity
    func accessItems(named name: String, inAmountOf number: Int = 0) -> (Good?, TransState) {
        
        let existingItems = items.filter { $0.key.name == name }

        guard let (item, quantity) = existingItems.first else { return (nil, .failure("There is no such item available anymore")) }
        
        if quantity! < number { return (nil, .failure("Doesn't have enough number of items")) }
        
        return (item, .success)
    }
    
    // Executed after successful completion Handler in AddItems func
    // Already cheched existance
    mutating func removeItems(named name: String, inAmountOf number: Int) {
        
//        print("removing items")
        
        let existingItems = items.filter { $0.key.name == name }
        guard let (item, availableQuantity) = existingItems.first else { return }
        guard var quantity = availableQuantity else { return }
        
        quantity -= number
        
        if quantity == 0 {
            items[item] = nil
        } else {
            items[item] = quantity
        }
    }
    
    mutating func addItems(named name: String, inAmountOf number: Int, withCompletionHandler comHandler: CompletionHandler) {
        
        guard let (availableItem, state) = delegate?.accessItems(named: name, inAmountOf: number) else { return }
        
        // fails only if there is no item in the stock/cart to remove
        if let availableItem = availableItem {
//            print("accessing available items from the store")
            let (existingItem, _) = accessItems(named: name)
            
            guard let item = existingItem else {
                items[availableItem] = number
                comHandler(true)
                return
            }
//            print("incrementing")
            // Increment counter
            if var quantity = items[item]! {
                print("new quantity is \(quantity)")
                quantity += number
                items[item] = quantity
            }
            comHandler(true)
        } else {
            switch state {
            case .failure(let localizedDesc):
                print(localizedDesc)
            default:
                break
            }
            // then don't proceed to removal from the stock/cart
            comHandler(false)
        }
    }
}
