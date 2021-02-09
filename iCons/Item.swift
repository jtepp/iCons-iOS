//
//  Item.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var name: String
    var category: String
    var sub: String = ""
    var available: Double
}
