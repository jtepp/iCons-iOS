//
//  ContentView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-25.
//

import SwiftUI
import Firebase
import UIKit

struct Welcome: View {


    
    @State var next = false;
    var body: some View {
        NavigationView{
        VStack {
            
            Button(action: {
                signIn()
            }, label: {
                Text("Sign In")
            })
            
        }
            NavigationLink(destination:Text("HI"), isActive: $next){
                Text("A")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}


func signIn () {

    OAuthProvider(providerID: "microsoft.com").getCredentialWith(_: nil){credential, error in

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

                UserDefaults.standard.setValue(authResult.user.displayName, forKey: "displayName")
                UserDefaults.standard.setValue(authResult.user.email, forKey: "email")
                
            }
        }
    }
}
