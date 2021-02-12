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
    @State var nextItems = [Item]()
    @State var showCart = false
    let PILLGONE:CGFloat = 200
    @State var pillOffset:CGFloat = 200
    @State var dragOffset:CGFloat = 0
    @State var msg = ""
    @State var subs = [stringID(s:"Mac"), stringID(s:"PC")]
    var body: some View {
        VStack {
            ZStack{
                ScrollView {
                    ForEach(subList(items: self.viewModel.items.filter({ (item) -> Bool in
                        item.category.lowercased() == category.lowercased() || category.lowercased() == "all"
                    })), id: \.self){ s in
                        
                        DropdownView(
                            items: filtered(array: $nextItems, sub: s),
                            cart: $cart, 
                            heading: s,
                            color: Color("green"),
                            textColor: .white,
                            secondTextColor: .white
                        )
                    }
                    .navigationTitle(category)
                    .navigationBarItems(trailing:
                                            
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
                }
                PillView(text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)
            }
            .onAppear{
                self.viewModel.fetchInOut(array: $nextItems)
        }
        }
    }
    
}

struct itemList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            itemList(cart: Binding<[String : Int]>.constant([String : Int]()), category: "All")
        }
    }
}


func subList(items: [Item]) -> [String] {
    var subs = [String]()
    items.forEach { (item) in
        if !subs.contains(item.sub) {
            subs.append(item.sub)
        }
    }
    return subs
}

func filtered(array: Binding<[Item]>, sub: String) -> Binding<[Item]> {
    let a = array.wrappedValue.filter { (i) -> Bool in
        i.sub.lowercased() == sub.lowercased()
    }
    return Binding<[Item]>.constant(a)
    
}
