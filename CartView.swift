//
//  CartView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-03.
//

import SwiftUI

struct CartView: View {
    let PILLGONE:CGFloat = -300
    @Binding var showCart: Bool
    @Binding var cart: [String: Int]
    @ObservedObject private var viewModel = ItemsViewModel()
    @State var confirming = false
    @State var roomText = ""
    @Binding var pillOffset:CGFloat
    @Binding var dragOffset:CGFloat
    @Binding var msg: String
    @Binding var show: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Cart")
                .font(.largeTitle)
                .bold()
            List(viewModel.items.filter({ (item) -> Bool in
                cart["\(item.id),\(item.name)"] != nil
            })){ item in
                CartItemView(showCart: $showCart, item: item.name, cart: $cart)
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {confirming = true}, label: {
                    Text("Send Order")
                        .padding()
                        .background(
                            Capsule()
                                .fill(cart.isEmpty ? Color.gray : Color("green"))
                        )
                })
                .disabled(cart.isEmpty)
                .sheet(isPresented: $confirming, content: {
                    ZStack {
                        Color("green")
                            .edgesIgnoringSafeArea(.all)
                            .colorScheme(.dark)
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    msg = sendEmail(cart:cart, r: $roomText, c: $showCart) ? "Order sent, check your email soon\nto see if your order was accepted" : "Error sending request\nCheck your network connection and try again"
                                    show = false
                                    cart = [String:Int]()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                        pillOffset = -75
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
                                            pillOffset = PILLGONE
                                            dragOffset = 0
                                        }

                                    }
                                }, label: {
                                    Text("Confirm")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(
                                            Capsule()
                                                .fill(rooms.contains(roomText) ? Color("green") : Color.gray)
                                                .colorScheme(.light)
                                        )

                            }).disabled(!rooms.contains(roomText))
                                .foregroundColor(.white)
                                Spacer()
                            }
                            TextField("Room", text: $roomText)
                                .keyboardType(.numberPad)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(
                                    Capsule()
                                        .fill(Color.white)

                                )
                                .padding(.horizontal,100)
                                .padding(.vertical, 20)

                            Text("Please enter a valid room number")
                                .foregroundColor(.white)
                                .font(.footnote)
                                .padding()
                                .opacity(!rooms.contains(roomText) ? 1 : 0)

                        }

                    }
            })
                .foregroundColor(.white)
                Spacer()
            }
            
        }
        .padding()
        .onAppear{
            self.viewModel.fetchData()
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


func sendEmail(cart: [String:Int], r: Binding<String>, c:Binding<Bool>) -> Bool {
    
    var itemNQ = [String]()
    var itemIDs = [String]()
    var itemQ = [String]()
    cart.forEach { (i) in
        let id = i.key.split(separator: ",")[0]
        let name = i.key.split(separator: ",")[1]
        
        itemNQ.append("\(name) x\(i.value)")
        itemIDs.append("\"\(id)\"")
        itemQ.append(String(i.value))
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
        return false
    }
    
    do {
        let response = try String(contentsOf: url)
        if response == "success" {
            c.wrappedValue = false
            return true
        }
        return false
    } catch {
        print("confirmation error")
        c.wrappedValue = false
        return false
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


