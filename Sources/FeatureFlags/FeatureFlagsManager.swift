//
//  FeatureFlagsManager.swift
//
//
//  Created by ahmed on 31/05/2024.
//

import Foundation

typealias FeaturesDict = [FeatureFlagKey: RegisterdFeature]

protocol FeatureFlagsManagerInterface {
    func register(
        flag: RegisterdFeature,
        forKey key: FeatureFlagKey
    )
    func getRegisterdFeature(forKey key: FeatureFlagKey) -> RegisterdFeature
}

class FeatureFlagsManager: FeatureFlagsManagerInterface {
    static let shared = FeatureFlagsManager()
    private var flags: FeaturesDict = [:]
    
    private init() {
        do {
            try getRemoteFeaturesFlags() {}
        } catch {
            print(error)
        }
    }
    
    /// can be used to register locally untill backend finishes implementation
    func register(
        flag: RegisterdFeature,
        forKey key: FeatureFlagKey
    ) {
        flags[key] = flag
    }
    
    func getRegisterdFeature(forKey key: FeatureFlagKey) -> RegisterdFeature {
        flags[key] ?? NullFeatureFlagModel()
    }
    
    private func getRemoteFeaturesFlags(_ completion: @escaping () -> Void) throws {
        #warning("Use a real api request here")
        
        do {
            /// handle new feature keys using unknown
            try makeJsonFeaturesData().forEach{
                register(
                    flag: $0,
                    forKey: $0.key
                )
            }
            completion()
        } catch {
            /// also throw decoding errors
            throw error
        }
    }
    
    private func makeJsonFeaturesData() throws -> [FeatureFlagModel]{
        let jsonData = """
            [
              {
                "key": "shopFeature",
                "is_enabled": true
              },
              {
                "key": "reviews",
                "is_enabled": true
              },
              {
                "key": "project",
                "is_enabled": false
              },
              {
                "key": "shouldFail",
                "is_enabled": false
              }
            ]
        """.data(using: .utf8)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let features = try decoder.decode([FeatureFlagModel].self, from: jsonData!)
            return features
        } catch {
            throw error
        }
    }
}

