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
    let PILLGONE:CGFloat = -200
    @State var msg = ""
    @State var pillOffset:CGFloat = -200
    @State var dragOffset:CGFloat = 0
    @Binding var item: Item
    @State var confirming = false
    @State var roomText = ""
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
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
                    .padding(.horizontal,20)
                    Spacer()
                    HStack {
                        
                        Button(action:{
                            confirming = true
                        }, label: {
                            Text("REQUEST")
                                .font(Font.system(size: 36, weight: .bold, design: .default))
                                .bold()
                                .offset(y:-20)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(
                                    RoundedRectangle(cornerRadius: 50)
                                        .fill(item.available <= 0 ? Color.gray : Color("green"))
                                )
                        })
                        .disabled(item.available <= 0)
                        .edgesIgnoringSafeArea(.all)
                        .offset(y:50)
                        .sheet(isPresented: $confirming, content: {
                            ZStack {
                                Color("green")
                                    .edgesIgnoringSafeArea(.all)
                                    .colorScheme(.dark)
                                VStack {
                                    Button(action: {
                                        msg = sendEmail(item:item, r: $roomText, c: $confirming) ? "Order sent, check your email soon\nto see if your order was accepted" : "Error sending request\nCheck your network connection and try again"
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                                pillOffset = -65
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
                        
                        
                        
                    }
                }
            }
            PillView(PILLGONE: PILLGONE, text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset, top: true)
            
        }
        
        
    }
}

struct itemInfo_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView{
            itemInfo(item: Binding<Item>.constant(Item(id: "", name: "Name", category: "Category", available: 4)))
        }
    }
}



func sendEmail(item:Item, r: Binding<String>, c:Binding<Bool>) -> Bool {
    let room = r.wrappedValue
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    let date = formatter.string(from: Date())
    let dn = UserDefaults.standard.string(forKey: "displayName")!
    let em = UserDefaults.standard.string(forKey: "email")!
    var html = "&h=<h1>Incoming order from Room \(room)</h1><p>From: \(dn)"
    html += "</p><p>Request: <b>\(item.name)</b></p><p>Date: \(date)"
    html += "</p><a href='https://iconsportal.netlify.app/response?id=[\"\(item.id)\"]%26date=\(date)"
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
