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
    @State var cartcount = 0
    @State var msg = ""
    @State var pillOffset:CGFloat = -200
    @State var dragOffset:CGFloat = 0
    @State var quantity = 1
    @State var quantityText = "1"
    @Binding var item: Item
    @State var showCart = false
    var db = Firestore.firestore()
    //    @State var current:Double = 0
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
                            Text(item.category+" - "+item.sub)
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
                                msg = "Cart now contains \(item.name) x\(quantity)"
                                ItemsViewModel().add(item: CartItem(item: item, quantity: quantity))
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                                    pillOffset = -75
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
                                        pillOffset = PILLGONE
                                        dragOffset = 0
                                    }
                                    
                                }
                                db.collection("cart/\(UserDefaults.standard.string(forKey: "email") ?? "empty")/cartitems").getDocuments { (snapshot, error) in
                                    cartcount = snapshot!.documents.count
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
                                    Image("greenbutton")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .colorMultiply((item.available <= 0 || quantity <= 0 || quantity > Int(item.available)) ? Color.gray : Color.white)
                                )
                            })
                            .disabled(item.available <= 0 || quantity <= 0 || quantity > Int(item.available))
                            .sheet(isPresented: $showCart, content: {
                                CartView(showCart: $showCart, pillOffset: $pillOffset, dragOffset: $dragOffset, msg: $msg, show: $showCart, cartcount: $cartcount)
                                
                            })
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color("green")]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
            )
            PillView(PILLGONE: PILLGONE, text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset, top: true)
            //                .onTapGesture {
            //                    pillOffset = PILLGONE
            //                    showCart = true
            //                }
            
        }
        .onAppear(){
            //            db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").document(item.id).addSnapshotListener({ (documentSnapshot, error) in
            //                       if documentSnapshot?.exists ?? false {
            //                           let d = documentSnapshot!.data()
            //                           current = d!["quantity"] as! Double
            //                       }
            //                   })
            db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").getDocuments { (snapshot, error) in
                cartcount = snapshot!.documents.count
            }
        }
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
        
        
    }
}

struct itemInfo_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView{
            itemInfo(item: Binding<Item>.constant(Item(id: "", name: "Name", category: "Category", available: 4)))
            
        }
    }
}


