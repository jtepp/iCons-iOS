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
    let done: Bool = false
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
            .toolbar{
                ToolbarItem(placement: .principal, content: {
                    Text(title)
                })
                
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    if done {
                        Button("Done") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    })
                
                
                
            }
        }
        .highPriorityGesture(dg)
    }
}
