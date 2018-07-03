//
//  Good.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

struct Good: Hashable {
    let name: String
    let price: Double
    let category: Categories
    
    var hashValue: Int{
        return name.hashValue
    }
    
    static func == (lhs: Good, rhs: Good) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price && lhs.category == rhs.category
    }
}
