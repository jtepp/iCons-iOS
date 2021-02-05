//
//  itemList.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-26.
//

import SwiftUI

struct itemList: View {
    @Binding var cart: [String: Int]
    var category: String
    @ObservedObject private var viewModel = ItemsViewModel()
    @State var showCart = false
    let PILLGONE:CGFloat = 200
    @State var pillOffset:CGFloat = 200
    @State var dragOffset:CGFloat = 0
    @State var msg = ""
    var body: some View {
        ZStack{
        List(viewModel.items.filter({ i -> Bool in
            i.category.lowercased() == category.lowercased() || category.lowercased() == "all"
        })
        
        ){ item in
            NavigationLink(destination: itemInfo(cart: $cart, item: Binding<Item>.constant(item))){
                    VStack(alignment:.leading) {
                        Text(item.name)
                            .font(.headline)
                            .padding(.vertical, 2)
                        Text(String(Int(item.available))+" remaining")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
                .navigationTitle(category)
            .onAppear(){
                self.viewModel.fetchData()
        }.navigationBarItems(trailing:
                                
                                Button(action:{showCart = true}){
                                    Image(systemName:"cart")
                                        .overlay(
                                            Text(String(cart.count))
                                                .font(.caption2)
                                                .foregroundColor(cart.count > 0 ? .white : .clear)
                                                .padding(4)
                                                .background(Circle().fill(cart.count > 0 ? Color.red : Color.clear))
                                                .offset(x: 10.0, y: -10)
                                        )
                                }
        )
        .sheet(isPresented: $showCart, content: {
            CartView(showCart: $showCart, cart: $cart, pillOffset: $pillOffset, dragOffset: $dragOffset, msg: $msg, show: $showCart)
            
        })
            PillView(text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)
        }
        }
       
}

//struct itemList_Previews: PreviewProvider {
//    static var previews: some View {
//        itemList(category: "All")
//    }
//}
