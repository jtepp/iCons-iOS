//
//  CartItem.swift
//  Pods
//
//  Created by Jacob Tepperman on 2021-02-12.
//

import Foundation

struct CartItem: Identifiable {
    var id = UUID()
    var item: Item
    var quantity: Int
}
