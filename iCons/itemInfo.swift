//
//  itemInfo.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI

struct itemInfo: View {
    @State var item: Item
    @State var confirming = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading){
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
        .navigationTitle(item.name)
        
    }
}

struct itemInfo_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView{
            itemInfo(item: Item(id: "", name: "Name", category: "Category", available: 4))
        }
    }
}

let d = DateFormatter()

func sendEmail(item:Item, c:Binding<Bool>) {
    do {
        let room = "220"
        var html = "&h=<h1>Incoming%20order%20from%20Room%20220</h1><p>From:%20"+UserDefaults.standard.string(forKey: "displayName")!
        html += "</p><p>Request:%20<b>" + item.name + "</b></p><p>Date:%20" + d.string(from: Date())
        html += "</p><a%20href='https://iconsportal.netlify.app/response?id=[\"" + item.id + "\"]%26date=" + d.string(from: Date())
        html += "%26room=" + room + "%26mail=" + UserDefaults.standard.string(forKey: "email")!
        html += "%26name=" + UserDefaults.standard.string(forKey: "displayName")!
        html += "'>Click%20to%20accept%20order%20on%20the%20iCons%20Portal</a>"
        let u = "https://iconsportal.netlify.app/.netlify/functions/email?s=Order%20from%20room%20" + room + html + "";
        let url = URL(string: u)!
        let response = try String(contentsOf: url)
        if response == "success" {
            c.wrappedValue = false
        }
    } catch {
        print("error in confirmation")
    }
}
