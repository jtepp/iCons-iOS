//
//  CartClass.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-12.
//

import Foundation

class CartClass: ObservableObject {
   @Published var itemList = [String:Int]()
}
