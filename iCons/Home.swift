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
    @State var signedOut = UserDefaults.standard.string(forKey: "displayName") == "" || UserDefaults.standard.string(forKey: "email") == ""
    @State var name = UserDefaults.standard.string(forKey: "displayName")
    @State var pillOffset:CGFloat = 200
    @State var dragOffset:CGFloat = 0
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
                            UserDefaults.standard.setValue("", forKey: "displayName")
                            UserDefaults.standard.setValue("", forKey: "email")
                            signedOut = true
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
                    name = UserDefaults.standard.string(forKey: "displayName")
                    if name != "" && !signedOut {
                        pillOffset = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                            pillOffset = PILLGONE
                            dragOffset = 0
                        }
                        
                    }
                }
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                        pillOffset = 0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
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
            })
            
            PillView(pillOffset: $pillOffset, dragOffset: $dragOffset)
            
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
    var body: some View {
        NavigationLink(destination: itemList(category: category)){
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
