//
//  CartItem.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI
import FirebaseFirestore

struct CartItemView: View {
    @Binding var showCart: Bool
    var item: CartItem
    @State var exists = true
    @Binding var cartcount: Int
    var db = Firestore.firestore()
    var body: some View {
        HStack { if exists {
            Text(item.item.name)
                .foregroundColor(.black)
                .bold()
            Spacer()
            HStack{
                Text(String(item.quantity))
                    .padding(5)
                    .foregroundColor(.black)
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
                        db.collection("cart/\(UserDefaults.standard.string(forKey: "email") ?? "empty")/cartitems").getDocuments { (snapshot, error) in
                            cartcount = snapshot!.documents.count
                        }
                    }
                
                
            }}
        }
    }
}
