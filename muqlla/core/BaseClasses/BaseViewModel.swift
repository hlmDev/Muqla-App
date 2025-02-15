//
//  BaseViewModel.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 15/02/2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor  open class BaseViewModelSUI: ObservableObject {
    
    public init() {}

    public var cancellables = Set<AnyCancellable>()
    
    @Published public var success: Bool? = nil
    @Published public var loading: Bool? = nil
}
