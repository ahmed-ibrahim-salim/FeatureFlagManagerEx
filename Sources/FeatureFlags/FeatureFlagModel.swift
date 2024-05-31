//
//  File.swift
//  
//
//  Created by ahmed on 31/05/2024.
//

import Foundation

protocol RegisterdFeature {
    func isFeatureEnabled() -> Bool
}

/// 2 concrete models
struct FeatureFlagModel: Codable, RegisterdFeature {
    
    let key: FeatureFlagKey
    let isEnabled: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decodeIfPresent(FeatureFlagKey.self, forKey: .key) ?? .unknown
        self.isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ??  false
    }
    
    func isFeatureEnabled() -> Bool {
        isEnabled
    }
    
    /// used for local registeration
    init(
        key: FeatureFlagKey,
        isEnabled: Bool
    ) {
        self.key = key
        self.isEnabled = isEnabled
    }
}

class NullFeatureFlagModel: RegisterdFeature {
    let key: FeatureFlagKey = .unknown
    let isEnabled = false
    
    func isFeatureEnabled() -> Bool {
        isEnabled
    }
        
}

/// database (Dictionary) keys using enums
enum FeatureFlagKey: String, Codable {
    case shopFeature
    case reviews
    case project
    
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let key = try container.decode(String.self)
        self = FeatureFlagKey(rawValue: key) ?? .unknown
    }
}


