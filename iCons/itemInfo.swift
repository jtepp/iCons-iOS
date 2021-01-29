//
//  itemInfo.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI
import FirebaseFirestore

struct itemInfo: View {
    @Binding var item: Item
    @State var confirming = false
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
                        
                        Button(action:{confirming = true}, label: {
                            Text("REQUEST")
                                .font(Font.system(size: 36, weight: .bold, design: .default))
                                .bold()
                                .offset(y:-20)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(
                                    RoundedRectangle(cornerRadius: 50)
                                        .fill(Color("green"))
                                )
                        })
                        .edgesIgnoringSafeArea(.all)
                        .offset(y:50)
                        .sheet(isPresented: $confirming, content: {
                            ZStack {
                                Color("green")
                                    .edgesIgnoringSafeArea(.all)
                                    .colorScheme(.dark)
                                Button(action: {
                                    sendEmail(item:item, c: $confirming)
                                    
                                    
                                }, label: {
                                    Text("Confirm")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(
                                            Capsule()
                                                .fill(Color("green"))
                                                .colorScheme(.light)
                                        )
                                    
                                })
                            }
                        })
                        
                        
                        
                    }
                }
            }
            
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



func sendEmail(item:Item, c:Binding<Bool>) {
    let room = "220"
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
        return
    }
    
    do {
        let response = try String(contentsOf: url)
        if response == "success" {
            c.wrappedValue = false
        }
        
    } catch {
        print("confirmation error")
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
