//
//  File.swift
//  
//
//  Created by ahmed on 31/05/2024.
//

import Foundation

protocol FeatureFlagClient: AnyObject {
    var isEnabled: Bool { get set }
    var featureKey: FeatureFlagKey {get}
    
    func isFeatureEnabled() -> Bool
    
    /// an updating state mechanism
    func recheckIfFeatureIsEnabled() -> Bool
}

extension FeatureFlagClient {
    func isFeatureEnabled() -> Bool {
        isEnabled
    }
    
    @discardableResult
    func recheckIfFeatureIsEnabled() -> Bool {
        isEnabled = FeatureFlagsManager.shared
            .getRegisterdFeature(forKey: featureKey)
            .isFeatureEnabled()
        return isEnabled
    }
}
