//
//  Modal View.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import SwiftUI

struct ModalView<Content: View>: View
{
    @Environment(\.presentationMode) var presentationMode
    let content: Content
    let title: String
    let dg = DragGesture()
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.title = title
    }
    
    var body: some View
    {
        NavigationView
        {
            ZStack (alignment: .top)
            {
                self.content
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal, content: {
                    Text(title)
                })
                

            })
        }
        .highPriorityGesture(dg)
    }
}
