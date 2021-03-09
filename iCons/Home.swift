//
//  Home.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Home: View {
    
    var microsoftProvider : OAuthProvider?
    
    init(){
        self.microsoftProvider = OAuthProvider(providerID: "microsoft.com")
    }
    
    let PILLGONE:CGFloat = 200
    let PILLGONE2:CGFloat = -300
    @State var cartcount = 0
    @State var pillOffset:CGFloat = 200
    @State var dragOffset:CGFloat = 0
    @State var msg = ""
    @State var pillOffset2:CGFloat = -200
    @State var dragOffset2:CGFloat = 0
    @State var msg2 = ""
    @State var signedOut = true
    @State var already = false
    @State var showCart = false
    var db = Firestore.firestore()
    var body: some View {
        ZStack { NavigationView {
            VStack {
                
                Text("How can we help you?")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                    .offset(y: -20)
                //                    RoundedRectangle(cornerRadius: 10)
                //                        .frame(width: UIScreen.main.bounds.width-40, height: 2)
                //                        .padding(.top, -5)
                
                NavigationLink(
                    destination: CategoryPicking(),
                    label: {
                        HomeButton(text: "REQUEST ITEMS")
                    })
                
                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "https://icon.engsoc.queensu.ca/hestia-front/team/")!)
                        
                    },
                    label: {
                        HomeButton(text: "MEET THE ICONS")
                    })
                
                NavigationLink(
                    destination: Hours(),
                    label: {
                        HomeButton(text: "HOURS OF OPERATION")
                    })
                
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
                    HomeButton(text: "SIGN OUT")
                })
                .padding(.bottom, 20)
                Spacer()
                
            }
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
                if UserDefaults.standard.string(forKey: "email") ?? nil != nil {
                db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").getDocuments { (snapshot, error) in
                    cartcount = snapshot!.documents.count
                }
                }
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
                CartView(showCart: $showCart, pillOffset: $pillOffset2, dragOffset: $dragOffset2, msg: $msg2, show: $showCart, cartcount: Binding<Int>.constant(0))
                
            })
        }
        
        .sheet(isPresented: $signedOut, content: {
                SignIn(cartcount: $cartcount, signedOut: $signedOut, microsoftProvider: self.microsoftProvider, already: $already, msg: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)}
        )
        PillView(PILLGONE: PILLGONE2, text: $msg2, pillOffset: $pillOffset2, dragOffset: $dragOffset2)
            .offset(y: PILLGONE2 * 2)
        
        PillView(text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)
            
        
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct HomeButton: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .padding()
            .shadow(radius: 10)
            .background(
                //            RoundedRectangle(cornerRadius: 20)
                //                .fill(Color("green"))
                Image("greenbutton")
                    .resizable()
                    //                            .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width-120, height: 100)
            )
            .frame(width: UIScreen.main.bounds.width-120, height: 100)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .padding(.bottom)
        
    }
}

