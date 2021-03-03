//
//  Home.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-25.
//

import SwiftUI
import Firebase

struct CategoryPicking: View {
    
    var microsoftProvider : OAuthProvider?
    
    init(){
        self.microsoftProvider = OAuthProvider(providerID: "microsoft.com")
    }
    
    let PILLGONE:CGFloat = 200
    @State var cartcount = 0
    @State var pillOffset:CGFloat = 200
    @State var dragOffset:CGFloat = 0
    @State var signedOut = true
    @State var already = false
    @State var msg = ""
    @State var showCart = false
    var db = Firestore.firestore()
    let categories = ["All", "Chargers", "Supplies", "Textbooks", "Cables", "Workbooks"]
    var body: some View {
        
        ZStack {
            NavigationView{
                VStack {
                    
                    
                    ForEach(categories, id: \.self){category in
                        CategoryLink(category: category)
                        Spacer()
                    }
                    
                    
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            ItemsViewModel().clear(cartcount: $cartcount)
                            UserDefaults.standard.setValue(nil, forKey: "displayName")
                            UserDefaults.standard.setValue(nil, forKey: "email")
                            signedOut = true
                            already = false
                        } catch {
                            print("sign out error")
                        }
                        
                    }, label: {
                        HStack {
                            Text("Sign Out")
                                .frame(width: 80)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    Capsule()
                                        .fill(Color("red"))
                                )
                        }
                    })
                    .padding(.bottom, 20)
                    Spacer()
                    
                }
                .onAppear{
                    if !signedOut && !already {
                        already = true
                        msg = "Welcome,\n\((UserDefaults.standard.string(forKey: "displayName") ?? "")!)"
                        pillOffset = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                            pillOffset = PILLGONE
                            dragOffset = 0
                        }
                        
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
                .sheet(isPresented: $showCart, content: {
                    CartView(showCart: $showCart, pillOffset: $pillOffset, dragOffset: $dragOffset, msg: $msg, show: $showCart, cartcount: Binding<Int>.constant(0))
                    
                })
            }
            .sheet(isPresented: $signedOut, content: {
                    SignIn(cartcount: $cartcount, signedOut: $signedOut, microsoftProvider: self.microsoftProvider, already: $already, msg: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)}
            )
            
            PillView(text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)
                .onTapGesture {
                    pillOffset = PILLGONE
                }
            
        }
        
    }
}


struct CGPreviews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
