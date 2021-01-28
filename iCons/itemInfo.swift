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
                    Button(action: {
                        confirming = true
                    }){
                        Text("REQUEST")
                            .font(Font.system(size: 36, weight: .bold, design: .default))
                            .bold()
                    }
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color("green"))
                    )
                    .offset(y:40)

                    
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
