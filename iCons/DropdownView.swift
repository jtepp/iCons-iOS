//
//  DropdownView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-02-06.
//

import SwiftUI

struct DropdownView: View {
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
                        ForEach(views.indices){ v in
                            views[v]
                                .offset(y:
                                            height == 40 ? 0 : CGFloat((v)*40-30)
                                )
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
                case 40: height = CGFloat(80+40*views.count)
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
                    DropdownView(views: testViews)
                    Spacer()
                }
            }
            
            
            
        }
    }
}

let testViews = [
    NavigationLink(
        destination: Text("Destination1"),
        label: {
            Text("Navigate1")
        }).anyview(),
    NavigationLink(
        destination: Text("Destination2"),
        label: {
            Text("Navigate2")
        }).anyview(),
    NavigationLink(
        destination: Text("Destination2"),
        label: {
            Text("Navigate2")
        }).anyview(),
    NavigationLink(
        destination: Text("Destination3"),
        label: {
            Text("Navigate3")
        }).anyview()
]

extension View {
    func anyview() -> AnyView {
        return AnyView(self)
    }
}
