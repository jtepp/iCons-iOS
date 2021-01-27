//
//  iConsApp.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-25.
//

import SwiftUI
import Firebase

@main
struct iConsApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}
