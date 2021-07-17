//
//  ProjectHeaderView.swift
//  UltimatePortfolio
//
//  Created by Vlad Vrublevsky on 04.05.2021.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                
                ProgressView(value: project.completionAmount)
                    .accentColor(Color(project.projectColor))
            }
            Spacer()
            
            NavigationLink(destination: EditProjectView(project: project)) {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
