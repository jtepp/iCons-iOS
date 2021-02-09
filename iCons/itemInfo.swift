//
//  itemInfo.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI
import FirebaseFirestore

let rooms = [
    "104",
    "218",
    "317",
    "105",
    "219",
    "318",
    "111",
    "220",
    "319",
    "112",
    "221",
    "320",
    "113",
    "222",
    "321",
    "116",
    "223",
    "322",
    "117",
    "224",
    "323",
    "118",
    "225",
    "324",
    "119",
    "227",
    "325",
    "120",
    "228",
    "327",
    "128",
    "229",
    "329",
    "129",
    "230",
    "330",
    "130",
    "231",
    "331",
    "131"
]

struct itemInfo: View {
    let PILLGONE:CGFloat = -300
    @Binding var cart: [String: Int]
    @State var msg = ""
    @State var pillOffset:CGFloat = -200
    @State var dragOffset:CGFloat = 0
    @State var quantity = 1
    @State var quantityText = "1"
    @Binding var item: Item
    @State var showCart = false
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.largeTitle)
                                .bold()
                                .padding(.top,-20)
                            Text(item.category)
                                .padding(.bottom,100)
                            Text(String(Int(item.available))+" remaining")
                                .font(.title)
                                .bold()
                            
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text("Quantity to order:")
                                TextField("", text: $quantityText)
                                    .onChange(of: quantityText, perform: { _ in
                                        if (Int(quantityText) ?? 0) < 0 {
                                            quantityText = String(abs(Int(quantityText)!))
                                        }
                                        if !quantityText.isEmpty {
                                            quantity = Int(quantityText) ?? 1
                                        }
                                    })
                                    .frame(width:50)
                                    .padding()
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            Button(action:{
                                cart[item.id+","+item.name] = quantity
                                msg = "Cart now contains \(quantity)x \(item.name)"
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                                    pillOffset = -65
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
                                        pillOffset = PILLGONE
                                        dragOffset = 0
                                    }
                                    
                                }
                            }, label: {
                                HStack {
                                    Image(systemName: "cart.badge.plus")
                                        .font(.title)
                                    Text("ADD TO CART")
                                        .font(.title)
                                        .bold()
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 50)
                                        .fill((item.available <= 0 || quantity <= 0 || quantity > Int(item.available)) ? Color.gray : Color("green"))
                                )
                            })
                            .disabled(item.available <= 0 || quantity <= 0 || quantity > Int(item.available))
                            .sheet(isPresented: $showCart, content: {
                                CartView(showCart: $showCart, cart: $cart, pillOffset: $pillOffset, dragOffset: $dragOffset, msg: $msg, show: $showCart)
                                
                            })
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            PillView(PILLGONE: PILLGONE, text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset, top: true)
            //                .onTapGesture {
            //                    pillOffset = PILLGONE
            //                    showCart = true
            //                }
            
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
        
        
    }
}

struct itemInfo_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView{
            itemInfo(cart: Binding<[String: Int]>.constant([String: Int]()), item: Binding<Item>.constant(Item(id: "", name: "Name", category: "Category", available: 4)))
            
        }
    }
}


