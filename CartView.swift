//
//  CartView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI

struct CartView: View {
    @Binding var showCart: Bool
    @Binding var cart: [String: Int]
    @ObservedObject private var viewModel = ItemsViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Cart")
                .font(.largeTitle)
                .bold()
            List(viewModel.items.filter({ (item) -> Bool in
                cart[item.id] != nil
            })){ item in
                CartItem(showCart: $showCart, item: Binding<Item>.constant(item), cart: $cart)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .padding()
        .onAppear{
            self.viewModel.fetchData()
        }
    }
}


struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(showCart: Binding<Bool>.constant(false), cart: Binding<[String : Int]>.constant(["Gy8DX8fx7DObQAjEpAlo": 2, "ZXbbu6hYiz0OMFGc7nYn" : 6]))
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
