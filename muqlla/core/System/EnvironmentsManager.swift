//
//  EnvironmentsManager.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 10/03/2025.
//

import Foundation

class EnvironmentManager {
    
    static let shared = EnvironmentManager()
    let constants = EnviromnentConstants.self
    private let configuration: [String: String]

    private init() {
        guard let path = Bundle.main.path(forResource: "config", ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let config = try? JSONDecoder().decode([String: String].self, from: jsonData) else {
            fatalError("Couldn't find config.json in bundle")
        }
        self.configuration = config
    }
    
    
    var SUPABASE_URL: String? { configuration[constants.SUPABASE_URL] }
    var SUPABASE_KEY: String? { configuration[constants.SUPABASE_KEY] }
}
