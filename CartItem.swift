//
//  CartItem.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI

struct CartItem: View {
    @Binding var showCart: Bool
    @Binding var item: Item
    @Binding var cart: [String: Int]
    @State var quantityText = "0"
    var body: some View {
        HStack {
            Text(item.name)
                .bold()
            Spacer()
            HStack{
                TextField("", text: $quantityText, onCommit: {
                    cart[item.id] = Int(quantityText) ?? 1
                    if cart[item.id]! < 1 {
                        cart.removeValue(forKey: item.id)
                    }
                })
                    .keyboardType(.numberPad)
                .frame(maxWidth: 40, maxHeight: 40)
                .padding(4)
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.red)
                        .cornerRadius(10)
                        .onTapGesture {
                            cart.removeValue(forKey: item.id)
                            if cart.isEmpty {
                                showCart = false
                            }
                        }
                

            }
        }
        .onAppear{
            quantityText = String(cart[item.id]!)
        }
    }
}
