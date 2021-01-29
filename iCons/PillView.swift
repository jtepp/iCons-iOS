//
//  PillView.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI

struct PillView: View {
    var showOnce: Bool = false
    @State var active = true
    @State var text: String = ""
    let PILLGONE:CGFloat = 200
    let top: Bool
    @State var pillOffset: CGFloat = 0
    @State var dragOffset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            Spacer()
            Text(text)
                .multilineTextAlignment(.center)
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
    func dismiss(delay: Int = 4) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            pillOffset = top ? (-1 * PILLGONE) : PILLGONE
            dragOffset = 0
        }
    }
    func show(showDelay: Int = 0, dismissDelay: Int = 4) {
        if active {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(showDelay)) {
                if showOnce {active = false}
                pillOffset = 0
                dismiss(delay: dismissDelay)
            }
        }
    }
}

