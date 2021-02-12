//
//  CartItem.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI

struct CartItemView: View {
    @Binding var showCart: Bool
    var item: CartItem
    @State var exists = true
    var body: some View {
        HStack { if exists {
            Text(item.item.name)
                .bold()
            Spacer()
            HStack{
                Text(String(item.quantity))
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                            .foregroundColor(.gray)
                    )
                
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.red)
                    .cornerRadius(10)
                    .onTapGesture {
                        exists = false
                        ItemsViewModel().delete(id: item.item.id)
                    }
                
                
            }}
        }
    }
}
