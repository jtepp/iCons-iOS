//
//  BlurView.swift
//  Stellar
//
//  Created by Noah Wilder on 2019-11-14.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import SwiftUI


struct BlurView: UIViewRepresentable {

    typealias UIViewType = UIVisualEffectView

    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIViewType {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return visualEffectView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

