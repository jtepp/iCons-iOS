//
//  Home.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

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
    let categories = ["Textbooks", "Chargers", "Cables", "Supplies", "Booklets", "Workbooks"]
    var body: some View {
        
        ZStack {
                Color.white
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("red")]), startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .padding(.horizontal, -100)
                .padding(.top, 100)
            VStack {
                ForEach(0..<Int(categories.count/2), id: \.self){category in
                    HStack {
                        CategoryLink(category: categories[category * 2])
                        Spacer()
                        CategoryLink(category: categories[category * 2 + 1])
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom)
                }
                
             
                NavigationLink(
                    destination: itemList(category: "All"),
                    label: {
                        Text("SEE ALL\nINVENTORY")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("red"))
                                    .padding(.vertical, -14)
                                    .padding(.horizontal, -60)
                            )
                    })
                Spacer()
            }
            .offset(y: 40)
            .navigationTitle("Categories")
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
//                                            .overlay(
//                                                Text(String(cartcount))
//                                                    .font(.caption2)
//                                                    .foregroundColor(cartcount > 0 ? .white : .clear)
//                                                    .padding(4)
//                                                    .background(Circle().fill(cartcount > 0 ? Color.red : Color.clear))
//                                                    .offset(x: 10.0, y: -10)
//                                            )
                                    }
            )
            .sheet(isPresented: $showCart, content: {
                CartView(showCart: $showCart, pillOffset: $pillOffset, dragOffset: $dragOffset, msg: $msg, show: $showCart, cartcount: Binding<Int>.constant(0))
                
            })
            
            
            PillView(text: $msg, pillOffset: $pillOffset, dragOffset: $dragOffset)
                .onTapGesture {
                    pillOffset = PILLGONE
                }
            
        }
        
    }
}


struct CGPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryPicking()
        }
    }
}


struct CategoryLink: View {
    var category: String
    var body: some View {
        NavigationLink(destination: itemList(category: category)){
            Text(category.uppercased())
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .shadow(radius: 10)
                .background(
                    //            RoundedRectangle(cornerRadius: 20)
                    //                .fill(Color("green"))
                    Image("redfolder")
                        .resizable()
                        //                            .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 110)
                )
                .frame(width: 130, height: 110)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .padding(.bottom)
        }
        
        
    }
}
