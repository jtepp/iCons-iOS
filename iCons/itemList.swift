//
//  itemList.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-26.
//

import SwiftUI
import FirebaseFirestore

struct itemList: View {
    @State var cartcount = 0
    var category: String
    @ObservedObject private var viewModel = ItemsViewModel()
    @State var nextItems = [Item]()
    @State var showCart = false
    let PILLGONE:CGFloat = 200
    @State var pillOffset:CGFloat = 200
    @State var dragOffset:CGFloat = 0
    @State var msg = ""
    @State var subs = [stringID(s:"Mac"), stringID(s:"PC")]
    var db = Firestore.firestore()
    var body: some View {
        VStack {
            ZStack{
                ScrollView {
                    ForEach(subList(items: Binding<[Item]>.constant(self.viewModel.items.filter({ (item) -> Bool in
                        item.category.lowercased() == category.lowercased() || category.lowercased() == "all"
                    }))).sorted(by: { (a, b) -> Bool in
                        a < b
                    })
                    
                    , id: \.self){ s in
                        
                        DropdownView(
                            items: filtered(array: $nextItems, sub: s),
                            heading: (category.lowercased() == "all") ? (s + " - " + casing(s: filtered(array: $nextItems, sub: s)[0].category.wrappedValue) ): s,
                            color: Color("blue"),
                            textColor: .white,
                            secondTextColor: .white
                        )
                    }
                    .navigationTitle(category)
                    .navigationBarItems(trailing:
                                            
                                            Button(action:{showCart = true}){
                                                Image(systemName:"cart")
                                                    .overlay(
                                                        Text(String(cartcount))
                                                            .font(.caption2)
                                                            .foregroundColor(cartcount > 0 ? .white : .clear)
                                                            .padding(4)
                                                            .background(Circle().fill(cartcount > 0 ? Color.red : Color.clear))
                                                            .offset(x: 10.0, y: -10)
                                                    )
                                            }
                    )
                    .sheet(isPresented: $showCart, onDismiss: {
                        nextItems = [Item]()
                        self.viewModel.fetchInOut(array: $nextItems)
                    }, content: {
                        CartView(showCart: $showCart, pillOffset: $pillOffset, dragOffset: $dragOffset, msg: $msg, show: $showCart, cartcount:$cartcount)
                        
                    })
                }
                PillView(text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)
            }
            .background(
                ZStack {
                    Color.white
                            LinearGradient(gradient: Gradient(colors: [Color.white, Color("blue")]), startPoint: .top, endPoint: .bottom)
                                .opacity(0.5)
                                .edgesIgnoringSafeArea(.all)
                                .padding(.horizontal, -100)
                                .padding(.top, 100)
                }
                        )
            .onAppear{
                self.viewModel.fetchInOut(array: $nextItems)
                db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").getDocuments { (snapshot, error) in
                    cartcount = snapshot!.documents.count
                }
        }
        }
    }
    
}

struct itemList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            itemList(category: "All")
        }
    }
}


func subList(items: Binding<[Item]>) -> [String] {
    var subs = [String]()
    items.wrappedValue.forEach { (item) in
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

func casing(s: String) -> String{
    return s.prefix(1).uppercased()+s.suffix(s.count-1).lowercased()
}
