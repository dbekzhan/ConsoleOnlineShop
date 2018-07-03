//
//  HelperFunctions.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

func getln() -> String {
    let stdin = FileHandle.standardInput
    var input = NSString(data: stdin.availableData, encoding: String.Encoding.utf8.rawValue)
    input = input!.trimmingCharacters(in: NSCharacterSet.newlines) as NSString
    return input! as String
}


func didAgree(toQuestion question: String) -> Bool {
    print(question + "y | n")
    let inp = getln()
    if inp.hasPrefix("y") { return true } else { return false }
}


// if let item = item {
//            guard var quantity = items[item]! else { return }
//            print("previous \(quantity)")
//            quantity += number
//            items[item] = quantity
//            print("new \(items[item])")
//        } else {
//            // check in stock
//            guard let (item, state) = delegate?.accessItems(named: name, inAmountOf: number) else { print("error is here"); return }
//            // unwrap optional item
//            if let item = item {
//                items[item] = number
//            } else {
//                switch state {
//                case .failure(let localizedDesc):
//                    print(localizedDesc)
//                default:
//                    break
//                }
//            }
//        }



//        if let posessedItem = availableItem {
//            guard var quantity = items[posessedItem]! else { return }
//            print("previous q \(quantity)")
//            quantity -= number
//            print("new q \(quantity)")
//
//            if quantity == 0 {
//                items[item] = nil
//                print("now there is no item")
//            } else {
//                items[item] = quantity
//            }
//
//            comHandler(true)
//
//        } else {
//            switch state {
//            case .failure(let localizedDesc):
//                comHandler(false)
//                print(localizedDesc)
//            default:
//                break
//            }
//        }
