//
//  File.swift
//  
//
//  Created by ahmed on 31/05/2024.
//

import Foundation


// MARK: Features clients
class ShopFeatureViewModel: FeatureFlagClient {
    var isEnabled: Bool = false
    let featureKey: FeatureFlagKey = .shopFeature
    
    init() {
        recheckIfFeatureIsEnabled()
    }

}
