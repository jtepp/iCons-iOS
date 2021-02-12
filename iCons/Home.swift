//
//  Home.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-25.
//

import SwiftUI
import Firebase
import UIKit

struct Home: View {
    
    var microsoftProvider : OAuthProvider?
    
    init(){
        self.microsoftProvider = OAuthProvider(providerID: "microsoft.com")
    }
    
    let PILLGONE:CGFloat = 200
    @State var cart = [CartItem]()
    @State var pillOffset:CGFloat = 200
    @State var dragOffset:CGFloat = 0
    @State var signedOut = true
    @State var already = false
    @State var msg = ""
    @State var showCart = false
    let categories = ["All", "Chargers", "Supplies", "Textbooks", "Cables", "Workbooks"]
    var body: some View {
        
        ZStack {
            NavigationView{
                VStack {
                    
                    
                    ForEach(categories, id: \.self){category in
                        CategoryLink(category: category, cart: $cart)
                        Spacer()
                    }
                    
                    
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            UserDefaults.standard.setValue(nil, forKey: "displayName")
                            UserDefaults.standard.setValue(nil, forKey: "email")
                            signedOut = true
                            already = false
                            cart = [CartItem]()
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
            .sheet(isPresented: $signedOut, content: {
                ModalView(title: "Welcome") {
                    Button(action: {
                        self.microsoftProvider?.getCredentialWith(_: nil){credential, error in
                
                            if error != nil {
                                // Handle error.
                            }
                
                            if let credential = credential {
                
                
                                Auth.auth().signIn(with: credential) { (authResult, error) in
                
                                    if error != nil {
                                        // Handle error.
                                    }
                
                                    guard let authResult = authResult else {
                                        print("Couldn't get graph authResult")
                                        return
                                    }
                                    signedOut = false
                                    UserDefaults.standard.setValue(authResult.user.displayName, forKey: "displayName")
                                    UserDefaults.standard.setValue(authResult.user.email, forKey: "email")
                                    print(UserDefaults.standard.string(forKey: "displayName")!)
                                    print(UserDefaults.standard.string(forKey: "email")!)
                                    already = true
                                    msg = "Welcome,\n\((UserDefaults.standard.string(forKey: "displayName") ?? "")!)"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                        pillOffset = 0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                            pillOffset = PILLGONE
                                            dragOffset = 0
                                        }
                
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Capsule()
                                    .fill(Color("green"))
                            )
                    }
                
                }
                .onAppear(){
                    if (UserDefaults.standard.string(forKey: "displayName") != nil && UserDefaults.standard.string(forKey: "email") != nil) {
                        msg = "Welcome,\n\((UserDefaults.standard.string(forKey: "displayName") ?? "")!)"
                        signedOut = false
                        already = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                            pillOffset = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                                pillOffset = PILLGONE
                                dragOffset = 0
                            }
                
                        }
                    }
                }
            })
           
            
            PillView(text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)
                .onTapGesture {
                    pillOffset = PILLGONE
                }
            
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct CategoryLink: View {
    var category: String
    @Binding var cart: [CartItem]
    var body: some View {
        NavigationLink(destination: itemList(cart: $cart, category: category)){
            HStack {
                Text(category)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .frame(width: 150)
        .foregroundColor(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("green"))
        )
        
    }
}

