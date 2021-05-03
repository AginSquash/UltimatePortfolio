//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Vlad Vrublevsky on 03.05.2021.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void ) -> Binding<Value> {
        Binding (
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            })
    }
}
