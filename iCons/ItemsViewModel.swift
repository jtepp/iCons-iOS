//
//  ItemsViewModel.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-27.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class ItemsViewModel: ObservableObject {
    @Published var items = [Item]()
    @Published var cart = [CartItem]()
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
                let sub = data["sub"] as? String ?? ""
                let available = data["available"] as? Double ?? 0
                
                return Item(id: queryDocumentSnapshot.documentID, name: name, category: category, sub: sub, available: available)
            }
        }
    }
    
    func fetchCart() {
        let e = UserDefaults.standard.string(forKey: "email")!
        db.collection("cart/\(e)/cartitems").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("empty cart")
                return
            }
            
            self.cart = documents.map({ (queryDocumentSnapshot) -> CartItem in
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let category = "_"
                let quantity = data["quantity"] as? Double ?? 0
                let cartitem = CartItem(item:Item(id: queryDocumentSnapshot.documentID, name: name, category: category, available: 0), quantity: Int(quantity))
                print(cartitem)
                return cartitem
            })
        }
    }
    
    func fetchInOut(array: Binding<[Item]>) {
        db.collection("items").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            self.items = documents.map { queryDocumentSnapshot -> Item in
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let sub = data["sub"] as? String ?? ""
                let available = data["available"] as? Double ?? 0
                return Item(id: queryDocumentSnapshot.documentID, name: name, category: category, sub: sub, available: available)
            }
            array.wrappedValue = self.items
        }
    }
    
    func delete(id: String){
        let e = UserDefaults.standard.string(forKey: "email")!
        db.document("cart/"+e+"/cartitems/"+id).delete()
    }
    
    func add(item: CartItem){
        self.set(item: item)
//        db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").document(item.item.id).getDocument { (documentSnapshot, error) in
//            if documentSnapshot?.exists ?? false {
//                self.increment(item: item)
//            } else {
//                self.set(item: item)
//            }
//        }
    }
    
    func set(item: CartItem){
        db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").document(item.item.id).setData(["id":item.item.id, "name":item.item.name,"quantity":item.quantity])
    }
    
    func increment(item: CartItem){
        db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").document(item.item.id).updateData(["quantity":FieldValue.increment(Int64(item.quantity))])
    }
    func clear() {
        db.collection("cart/\(UserDefaults.standard.string(forKey: "email")!)/cartitems").getDocuments { (querySnapshot, error) in
            querySnapshot?.documents.forEach({ (doc) in
                doc.reference.delete()
            })
        }
        db.collection("cart").document(UserDefaults.standard.string(forKey: "email")!).delete()
    }
}
