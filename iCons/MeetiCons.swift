//
//  MeetiCons.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-03-08.
//

import SwiftUI
import Firebase

struct MeetiCons: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("blue")]), startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            ScrollView{
                
            }
        }
        .navigationTitle("Meet the iCons")
    }
}



struct MeetiCons_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MeetiCons()
        }
    }
}
