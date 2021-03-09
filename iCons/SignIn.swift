//
//  SignIn.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-03-03.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignIn: View {
    let PILLGONE:CGFloat = 200
    @Binding var cartcount: Int
    @Binding var signedOut: Bool
    var microsoftProvider: OAuthProvider?
    @Binding var already: Bool
    @Binding var msg: String
    @Binding var pillOffset: CGFloat
    @Binding var dragOffset: CGFloat
    var db = Firestore.firestore()
    var body: some View {
        ModalView(title: "Welcome") {
            ZStack{
                Color.white
                Image("ILC")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    
                VStack {
                    Image("hours")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width-100)
                        
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
                    Text("SIGN IN WITH NETID")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("red"))
                        )
                    }
                }
        
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
            db.collection("cart/\(UserDefaults.standard.string(forKey: "email") ?? "empty")/cartitems").getDocuments { (snapshot, error) in
                cartcount = snapshot!.documents.count
            }
            
        }
    }
    }
