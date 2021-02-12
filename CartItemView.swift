//
//  CartItem.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI

struct CartItemView: View {
    @Binding var showCart: Bool
    var item: String
    @Binding var cart: [CartItem]
    @State var quantityText = "0"
    @State var exists = true
    var body: some View {
        HStack { if exists {
            Text(item)
                .bold()
            Spacer()
            HStack{
                Text(String(quantityText))
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
                        cart.removeAll { (i) -> Bool in
                            i.item.name == item
                        }
                        if cart.isEmpty {
                            showCart = false
                        }
                    }
                
                
            }}
        }
        .onAppear{
            quantityText = String(cart.first { (i) -> Bool in
                i.item.name == item
            }?.quantity ?? 0)
        }
    }
}
