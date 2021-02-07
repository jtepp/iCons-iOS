//
//  DropdownView.swift
//  Pods
//
//  Created by Jacob Tepperman on 2021-02-06.
//

import SwiftUI

struct DropdownView: View {
    var views: [Any]
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
                case 40: height = CGFloat(40*views.count)
                default: height = 40
                }
                
            }
        }.animation(.easeOut)
        
    }
}

struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("green")
            DropdownView(views: testViews)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

let testViews = [
    NavigationLink(
        destination: Text("Destination1"),
        label: {
            Text("Navigate1")
        }),
    NavigationLink(
        destination: Text("Destination2"),
        label: {
            Text("Navigate2")
        }),
    NavigationLink(
        destination: Text("Destination2"),
        label: {
            Text("Navigate2")
        }),
    NavigationLink(
        destination: Text("Destination3"),
        label: {
            Text("Navigate3")
        })
]
