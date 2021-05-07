//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Vlad Vrublevsky on 25.04.2021.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    @State private var showingSortOrder: Bool = false
    @State private var sortOrder: Item.SortOrder = .optimized
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(header: ProjectHeaderView(project: project)) {
                        ForEach(items(for: project)) { item in
                            ItemRowView(item: item)
                        }
                        .onDelete(perform: { offsets in
                            /// Force push changes
                            // dataController.container.viewContext.processPendingChanges()
                            let allItems = project.projectItems
                            
                            for offset in offsets {
                                let item = allItems[offset]
                                dataController.delete(item)
                            }
                            dataController.save()
                        })
                        
                        if showClosedProjects == false {
                            Button {
                                withAnimation {
                                    let item = Item(context: managedObjectContext)
                                    item.project = project
                                    item.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add new Item", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedProjects == false {
                        
                        Button {
                           withAnimation {
                               let project = Project(context: managedObjectContext)
                               project.closed = false
                               project.creationDate = Date()
                               dataController.save()
                           }
                       } label: {
                           Label("Add Project", systemImage: "plus")
                       }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSortOrder.toggle() }, label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    })
                }
                
            })
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized"), action: { sortOrder = .optimized}),
                    .default(Text("Creation Date"), action: { sortOrder = .creationDate }),
                    .default(Text("Title"), action: { sortOrder = .title })
                ])
            }
        }
    }
    
    func items(for project: Project) -> [Item] {
        switch sortOrder {
        case .title:
            return project.projectItems.sorted { $0.itemTitle < $1.itemTitle }
        case .creationDate:
            return project.projectItems.sorted { $0.itemCreationDate < $1.itemCreationDate }
        case .optimized:
            return project.projectItemsDefaultSorted
        }
    }
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            
    }
}
