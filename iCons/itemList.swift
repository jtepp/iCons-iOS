//
//  itemList.swift
//  iCons
//
//  Created by Jacob Tepperman on 2021-01-26.
//

import SwiftUI

struct itemList: View {
    var category: String
    @ObservedObject private var viewModel = ItemsViewModel()
    var body: some View {
            List(viewModel.items){ item in
                NavigationLink(destination: itemInfo(item: item)){
                    VStack(alignment:.leading) {
                        Text(item.name)
                            .font(.headline)
                            .padding(.vertical, 2)
                        Text(String(Int(item.available))+" remaining")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
                .navigationTitle(category)
            .onAppear(){
                self.viewModel.fetchData()
        }
        }
       
}

struct itemList_Previews: PreviewProvider {
    static var previews: some View {
        itemList(category: "All")
    }
}
