//
//  stringID.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-08.
//

import Foundation

struct stringID: Identifiable, Equatable {
    var id = UUID()
    var s: String
}
