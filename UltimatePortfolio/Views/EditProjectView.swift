//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Vlad Vrublevsky on 05.05.2021.
//

import SwiftUI

struct EditProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            self.color = item
                            update()
                        }
                    }
                }
                .padding(.vertical)
            }
            
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.").padding(.horizontal)) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }
                
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"),message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), primaryButton: .destructive(Text("Delete"), action: delete), secondaryButton: .cancel())
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
    
    init(project: Project) {
        self.project = project
        
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
