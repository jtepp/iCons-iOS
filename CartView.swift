//
//  CartView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI
import UIKit



struct CartView: View {
    let PILLGONE:CGFloat = -300 * 2
    @Binding var showCart: Bool
    @ObservedObject private var viewModel = ItemsViewModel()
    @State var confirming = false
    @State var roomText = ""
    @Binding var pillOffset:CGFloat
    @Binding var dragOffset:CGFloat
    @Binding var msg: String
    @Binding var show: Bool
    @Binding var cartcount: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Cart")
                .font(.largeTitle)
                .foregroundColor(.black)
                .bold()
            ScrollView {
                ForEach(viewModel.cart){ item in
                    CartItemView(showCart: $showCart, item: item, cartcount: $cartcount)
                    Divider()
                }
                .padding(.horizontal)
                
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {confirming = true}, label: {
                    HomeButton(text: "SEND ORDER")
                        .colorMultiply(cartcount > 0 ? Color.white : Color.gray)
                })
                .disabled(viewModel.cart.isEmpty)
                .sheet(isPresented: $confirming, content: {
                    ZStack{
                            Color.white
                            LinearGradient(gradient: Gradient(colors: [Color.white, Color("green")]), startPoint: .top, endPoint: .bottom)
                                .opacity(0.5)
                                .edgesIgnoringSafeArea(.all)
                                .padding(.horizontal, -100)
                                .padding(.top, 100)
                        VStack {
                            Text("Confirm your order")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                            TextField("Room", text: $roomText)
                                .keyboardType(.numberPad)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .foregroundColor(.black)
                                .background(
                                    Capsule()
                                        .fill(Color.white)
                                    
                                )
                                .padding(.horizontal,100)
                                .padding(.vertical, 20)
                            
                            Text("Please enter a valid room number")
                                .foregroundColor(.black)
                                .font(.footnote)
                                .padding()
                                .opacity(!rooms.contains(roomText) ? 1 : 0)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    let emailReturn = sendEmail(cart:$viewModel.cart, r: $roomText, c: $showCart, cc: $cartcount, vm: viewModel)
                                    msg = emailReturn == 0 ? "Order sent, check your email soon\nto see if your order was accepted" : (emailReturn == 2 ? "Error retrieving cart\nPlease close the app and try again" : "Error sending request\nCheck your network connection and try again")
                                    show = false
                                    confirming = false
                                    showCart = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                        pillOffset = -75
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
                                            pillOffset = PILLGONE*2
                                            dragOffset = 0
                                        }
                                        
                                    }
                                }, label: {
                                    HomeButton(text: "CONFIRM")
                                        .colorMultiply(rooms.contains(roomText) ? Color.white : Color.gray)
                                                
                                    
                                }).disabled(!rooms.contains(roomText))
                                .foregroundColor(.white)
                                Spacer()
                            }
                        }}
                })
                .foregroundColor(.white)
                Spacer()
            }
            
        }
        .padding()
        .background(
            ZStack {
                Color.white
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("green")]), startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .padding(.horizontal, -100)
                .padding(.top, 100)
            }
        )
        .onAppear{
            self.viewModel.fetchData()
            self.viewModel.fetchCart()
        }
    }
}


//struct CartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartView(showCart: Binding<Bool>.constant(false), cart: Binding<[String : Int]>.constant(["Gy8DX8fx7DObQAjEpAlo": 2, "ZXbbu6hYiz0OMFGc7nYn" : 6]))
//    }
//}
//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}


func sendEmail(cart: Binding<[CartItem]>, r: Binding<String>, c:Binding<Bool>, cc: Binding<Int>, vm: ItemsViewModel) -> Int {
    
    var itemNQ = [String]()
    var itemIDs = [String]()
    var itemQ = [String]()
    cart.wrappedValue.forEach { (i) in
        let id = i.item.id
        let name = i.item.name
        
        itemNQ.append("\(name) x\(i.quantity)")
        itemIDs.append("\"\(id)\"")
        itemQ.append(String(i.quantity))
    }
    
    let room = r.wrappedValue
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    let date = formatter.string(from: Date())
    let dn = UserDefaults.standard.string(forKey: "displayName")!
    let em = UserDefaults.standard.string(forKey: "email")!
    var html = "&h=<h1>Incoming order from Room \(room)</h1><p>From: \(dn)"
    html += "</p><p>Request: <b>\(itemNQ.joined(separator: ", "))</b></p><p>Date: \(date)"
    html += "</p><a href='https://iconsportal.netlify.app/response?id=[\(itemIDs.joined(separator: ","))]%26quantities=[\(itemQ.joined(separator: ","))]%26date=\(date)"
    html += "%26room=\(room)%26mail=\(em)"
    html += "%26name=\(dn)"
    html += "'>Click to accept order on the iCons Portal</a>"
    let u = "https://iconsportal.netlify.app/.netlify/functions/email?s=Order from room \(room)\(html)"
    guard let url = u.getCleanedURL() else {
        print("invalid url")
        return 1
    }
    if !itemIDs.isEmpty {
    do {
        c.wrappedValue = false
        let response = try String(contentsOf: url)
        if response == "success" {
            cc.wrappedValue = 0
            vm.clear(cartcount: cc)
            return 0
        }
        return 1
    } catch {
        print("confirmation error")
        c.wrappedValue = false
        return 1
    }
    } else {
        print("empty cart error")
        c.wrappedValue = false
        return 2
    }
    
}

extension String {
    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
    }
}


