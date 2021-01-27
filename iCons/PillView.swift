//
//  PillView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI

struct PillView: View {
    let PILLGONE:CGFloat = 200
    @Binding var pillOffset: CGFloat
    @Binding var dragOffset: CGFloat
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            Spacer()
            Text("Welcome,\n"+UserDefaults.standard.string(forKey: "displayName")!)
                .foregroundColor(.primary)
                .font(.footnote)
                .frame(maxHeight:40)
                .padding(.init(top: 4, leading: 14, bottom: 4, trailing: 14))
                .background(
                    BlurView(style: colorScheme == .light ? .light : .dark)
                        .clipShape(
                            Capsule()
                        )
                        .shadow(radius: 3)
                )
                .animation(Animation.easeOut(duration: 1.5).speed(3))
                .offset(x: 0, y: pillOffset+dragOffset)
                .onTapGesture(perform: {
                    pillOffset = PILLGONE
                })
                .gesture(
                    DragGesture()
                        .onChanged{ gesture in
                            dragOffset = abs(gesture.translation.height)
                            
                        }
                        .onEnded{ _ in
                            pillOffset = PILLGONE
                        }
                    
                )
            
            
            
        }
    }
}

