//
//  EditItemView.swift
//  UltimatePortfolio
//
//  Created by Vlad Vrublevsky on 28.04.2021.
//

import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var dataController: DataController
    let item: Item
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Basic setting")) {
                TextField("Item name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: dataController.save)
        /// Legacy. Now we will use .onChange(_ handler)
        /*
        .onChange(of: title, perform: { _ in update() })
        .onChange(of: detail, perform: { _ in update() })
        .onChange(of: priority, perform: { _ in update() })
        .onChange(of: completed, perform: { _ in update() })
         */
    }
    
    func update() {
        item.project?.objectWillChange.send()
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
    
    init(item: Item) {
        self.item = item
        
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
