//
//  Global.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 16/02/2025.
//

import Foundation
import SwiftUI

class Global: ObservableObject {
    static let shared = Global()
    @Published var showTabBar: Bool = true
}
