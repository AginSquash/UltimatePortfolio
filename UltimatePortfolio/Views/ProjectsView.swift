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
    
    var projectList: some View {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(header: ProjectHeaderView(project: project)) {
                        ForEach(project.projectItems(using: sortOrder)) { item in
                            ItemRowView(project: project, item: item)
                        }
                        .onDelete(perform: { offsets in
                            delete(offsets, from: project)
                            dataController.save()
                        })
                        
                        if showClosedProjects == false {
                            Button {
                                addItem(to: project)
                            } label: {
                                Label("Add New Item", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
    }
    
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
                
                Button(action: addProject) {
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Project")
                    } else {
                        Label("Add Project", systemImage: "plus")
                    }
                }
                
            }
        }
    }
    
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { showingSortOrder.toggle() }, label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            })
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.count == 0 {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    projectList
                }
                SelectSomethingView()
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar(content: {
                addProjectToolbarItem
                sortOrderToolbarItem
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
    
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }
    
    func delete(_ offsets: IndexSet, from project: Project) {
        /// Force push changes
        // dataController.container.viewContext.processPendingChanges()

        let allItems = project.projectItems(using: sortOrder)
        
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        
        dataController.save()
    }
    
    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
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
