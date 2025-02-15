//
//  BaseClassses+Extensions.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 15/02/2025.
//

import SwiftUI

extension View {
    public func wrapInsideBaseView(baseViewModel: BaseViewModelSUI) -> some View {
        BaseView(baseViewModel) {
            self
        }
    }
    public func wrapInsideBaseView() -> some View {
        BaseView {
            self
        }
    }
    
    public func wrapInsideAutoFocusScrollView() -> some View {
        AutoFocusScrollView {
            self
        }
    }
}
