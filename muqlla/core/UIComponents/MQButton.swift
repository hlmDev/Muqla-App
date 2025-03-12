//
//  MQButton.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 11/03/2025.
//

import SwiftUI

struct MQButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    
    init(action: @escaping () -> Void = {}, label: @escaping () -> Label = {EmptyView()}) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action, label: label)
    }
}
