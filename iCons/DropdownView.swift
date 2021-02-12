//
//  DropdownView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-06.
//

import SwiftUI

struct DropdownView: View {
//    @ObservedObject private var viewModel = ItemsViewModel()
    @Binding var items: [Item]
    @Binding var cart: [String: Int]
    var heading: String = "Heading"
    var width: CGFloat = UIScreen.main.bounds.width-40
    var color: Color = Color.clear
    var textColor: Color = .primary
    var secondTextColor: Color = .secondary
    @State var height: CGFloat = 40
    @State var imageRotation: Double = 0
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            
            Group {
                if color == Color.clear {
                    BlurView(style: colorScheme == .light ? .light : .dark)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(color)
                    
                }
            }
            .frame(width: width, height: height)
            .overlay(
                ZStack {
                    HStack {
                        VStack {
                            ForEach(items.indices, id: \.self){ i in
                                NavigationLink(
                                    destination: itemInfo(cart: $cart, item: Binding<Item>.constant(items[i]))
                                ){
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(items[i].name)
                                                .foregroundColor(textColor)
                                                .font(.system(size: 14, weight: .semibold, design:.default))
                                            Text(String(Int(items[i].available))+" remaining")
                                                .font(.footnote)
                                                .foregroundColor(secondTextColor)
                                                .offset(y:
                                                            height == 40 ? -4 : 0
                                                )
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right.circle")
                                            .foregroundColor(textColor)
                                            .padding(.trailing, -12)
                                    }
                                    .overlay(
                                        Rectangle()
                                            .fill(i == items.count - 1 ? Color.clear : secondTextColor)
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
                .opacity(height == 40 ? 0 : 1)
            )
            
            
            
            HStack {
                Text(heading)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(Angle(degrees: imageRotation))
            }
            .foregroundColor(textColor)
            .padding()
            .frame(width: width)
            .background(
                Group {
                    if color == Color.clear {
                        BlurView(style: colorScheme == .light ? .light : .dark)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 20)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color)
                            .padding(.horizontal, 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                                    .padding(.horizontal, 1)
                            )
                        
                        
                    }
                }
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

//struct DropdownView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        NavigationView {
//            
//            ZStack {
//                Color("green")
//                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    DropdownView()
//                    Spacer()
//                }
//            }
//            
//            
//            
//        }
//    }
//}

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


func infoViewsArray(items: [Item], cart: Binding<[String:Int]>) -> [AnyView] {
    var array = [AnyView]()
    items.forEach { (item) in
        array.append(
            itemInfo(cart: cart, item: Binding<Item>.constant(item)).anyview()
        )
    }
    return array
}
