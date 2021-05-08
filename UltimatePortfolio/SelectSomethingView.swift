//
//  SelectSomethingView.swift
//  UltimatePortfolio
//
//  Created by Vlad Vrublevsky on 09.05.2021.
//

import SwiftUI

struct SelectSomethingView: View {
    var body: some View {
        Text("Please select something from the menu to begin.")
            .italic()
            .foregroundColor(.secondary)
    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
