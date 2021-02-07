//
//  DropdownView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-06.
//

import SwiftUI

struct DropdownView: View {
    var items: [Item]
    var views: [AnyView]
    var heading: String = "Heading"
    var width: CGFloat = UIScreen.main.bounds.width-40
    @State var height: CGFloat = 40
    @State var imageRotation: Double = 0
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            BlurView(style: colorScheme == .light ? .light : .dark)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
                .frame(width: width, height: height)
                .overlay(
                    ZStack {
                        HStack {
                            VStack {
                                ForEach(items.indices){ i in
                                    NavigationLink(destination: views[i]){
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(items[i].name)
                                                    .foregroundColor(.primary)
                                                    .font(.system(size: 14, weight: .semibold, design:.default))
                                                Text(String(Int(items[i].available))+" remaining")
                                                    .font(.footnote)
                                                    .foregroundColor(.secondary)
                                                    .offset(y:
                                                                height == 40 ? -4 : 0
                                                    )
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right.circle")
                                                .foregroundColor(.primary)
                                                .padding(.trailing, -12)
                                        }
                                        .overlay(
                                            Rectangle()
                                                .fill(i == items.count - 1 ? Color.clear : Color.secondary)
                                            .frame(width:width-20, height: 1)
                                                .offset(x: 4, y:
                                            height == 40 ? -4 : 20
                                            )
                                        )
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 40)
                                    .offset(y:
                                                height == 40 ? CGFloat(dumbNum(i: i, count: items.count) * -40) : 25
                                    )
                                    
                                }
                            }
                            Spacer()
                        }
                        
                    }
                )
            
            
            
            HStack {
                Text("Heading")
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(Angle(degrees: imageRotation))
            }
            .padding()
            .frame(width: width)
            .background(
                BlurView(style: colorScheme == .light ? .light : .dark)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
            )
            .onTapGesture {
                switch(imageRotation){
                case 0: imageRotation = 90
                default: imageRotation = 0
                }
                switch(height){
                case 40: height = CGFloat(60+40*items.count)
                default: height = 40
                }
                
            }
        }.animation(.easeOut)
        
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            
            ZStack {
                Color("green")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    DropdownView(items: testItems, views: testViews)
                    Spacer()
                }
            }
            
            
            
        }
    }
}

let testItems = [Item(id: "", name: "Scissors", category: "Supplies", available: 30),Item(id: "", name: "Paper", category: "Supplies", available: 18),Item(id: "", name: "Charger", category: "Chargers", available: 9),Item(id: "", name: "Paper", category: "Supplies", available: 18),Item(id: "", name: "Charger", category: "Chargers", available: 9),Item(id: "", name: "Paper", category: "Supplies", available: 18),Item(id: "", name: "Charger", category: "Chargers", available: 9),Item(id: "", name: "Paper", category: "Supplies", available: 18),Item(id: "", name: "Charger", category: "Chargers", available: 9)]

let testViews = [
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview(),
    Text("asfasd").anyview()
]

extension View {
    func anyview() -> AnyView {
        return AnyView(self)
    }
}

func dumbNum(i:Int, count:Int) -> CGFloat {
    return CGFloat(Double(i) - Double(count)/2)
}
