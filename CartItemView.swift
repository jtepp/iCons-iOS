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
    @ObservedObject var cart: CartClass
    @State var quantityText = "0"
    @State var exists = true
    var body: some View {
        HStack { if exists {
            Text(item.split(separator: ",")[1])
                .bold()
            Spacer()
            HStack{
                Text(String(cart.itemList[item]!))
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
                        cart.itemList.removeValue(forKey: item)
                        if cart.itemList.isEmpty {
                            showCart = false
                        }
                    }
                
                
            }}
        }
        .onAppear{
            quantityText = String(cart.itemList[item] ?? 0)
        }
    }
}
