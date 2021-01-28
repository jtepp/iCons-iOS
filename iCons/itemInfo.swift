//
//  itemInfo.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI

struct itemInfo: View {
    @Binding var item: Item
    var body: some View {
        Text(item.name)
    }
}
