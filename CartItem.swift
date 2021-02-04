//
//  CartItem.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI

struct CartItem: View {
    @Binding var showCart: Bool
    var item: String
    @Binding var cart: [String: Int]
    @State var quantityText = "0"
    @State var exists = true
    var body: some View {
        HStack { if exists {
            Text(item.split(separator: ",")[1])
                .bold()
            Spacer()
            HStack{
                Text(String(cart[item]!))
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
                        cart.removeValue(forKey: item)
                        if cart.isEmpty {
                            showCart = false
                        }
                    }
                
                
            }}
        }
        .onAppear{
            quantityText = String(cart[item] ?? 0)
        }
    }
}
