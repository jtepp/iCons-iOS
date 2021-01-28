//
//  ItemsViewModel.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import Foundation
import FirebaseFirestore

class ItemsViewModel: ObservableObject {
    @Published var items = [Item]()
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("items").addSnapshotListener{ (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.items = documents.map { queryDocumentSnapshot -> Item in
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let available = data["available"] as? Double ?? 0
                
                
                return Item(id: queryDocumentSnapshot.documentID, name: name, category: category, available: available)
            }
        }
    }
}
