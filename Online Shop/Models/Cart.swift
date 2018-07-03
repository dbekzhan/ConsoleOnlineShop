//
//  Cart.swift
//  Online Shop
//
//  Created by Dimash Bekzhan on 7/2/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation

final class Cart: Storagable {
    
    var items: [Good : Int?] = [:]
    var delegate: Storagable?
}
