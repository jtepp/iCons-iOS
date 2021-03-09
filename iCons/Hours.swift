//
//  Hours.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-03-08.
//

import SwiftUI

struct Hours: View {
    var body: some View {
        ZStack {
            Color.white
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("red")]), startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image("redbutton")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width-80, alignment: .center)
                    .overlay(
                        VStack{
                            Text("ILC")
                                .font(.system(size: 40, weight: .bold))
                                .padding(.bottom,10)
                            Text("Monday to Thursday")
                            Text("5:30 PM - 11:30 PM")
                                .foregroundColor(Color("red"))
                                .font(.system(size: 24, weight: .black))
                            Text("Saturday")
                            Text("11:30 AM - 7:00 PM")
                                .foregroundColor(Color("red"))
                                .font(.system(size: 24, weight: .black))
                            Text("Sunday")
                            Text("10:00 AM - 11:00 PM")
                                .foregroundColor(Color("red"))
                                .font(.system(size: 24, weight: .black))
                            
                        }
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    )
                    .padding(.bottom, 20)
                Image("redbutton")
                    .resizable()
//                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width-80, height: 200, alignment: .center)
                    .overlay(
                        VStack{
                            Text("Stirling Hall")
                                .font(.system(size: 40, weight: .bold))
                                .padding(.bottom,10)
                            Text("Monday to Thursday")
                            Text("5:30 PM - 11:30 PM")
                                .foregroundColor(Color("red"))
                                .font(.system(size: 24, weight: .black))
                        }
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    )
                Spacer()
                }
                .offset(y:40)
            .navigationTitle("Hours of Operation")
        }
    }
}



struct Hours_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Hours()
        }
    }
}
