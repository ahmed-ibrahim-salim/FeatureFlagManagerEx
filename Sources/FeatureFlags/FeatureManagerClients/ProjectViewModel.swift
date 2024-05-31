//
//  File.swift
//  
//
//  Created by ahmed on 31/05/2024.
//

import Foundation

class ProjectViewModel: FeatureFlagClient {
    var isEnabled: Bool = false
    let featureKey: FeatureFlagKey = .project
    
    init() {
        recheckIfFeatureIsEnabled()
    }
    
}
