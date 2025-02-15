//
//  BaseView.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 15/02/2025.
//

import SwiftUI


public struct BaseView<Content: View>: View {
    let content: Content
    @ObservedObject public var viewModel = BaseViewModelSUI()
    
    public init(_ viewModel: BaseViewModelSUI, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .onReceive(viewModel.$loading) { loading in }
            .removeKeyboardOnTap()
    }
}
