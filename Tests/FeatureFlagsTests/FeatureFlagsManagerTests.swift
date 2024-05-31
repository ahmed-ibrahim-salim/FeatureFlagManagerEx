//
//  FeatureFlagsManagerTests.swift
//  
//
//  Created by ahmed on 31/05/2024.
//

import XCTest
@testable import swift

/// x local register features as enabled then feature is enabled
/// x local register features as disabled then feature is disabled
/// x get remote register list of feature flags
/// x get remote register list of feature flags with new feature flag key, we use unknown
/// x get remote register list of feature flags with wrong json format, we throw decoding error

final class FeatureFlagsManagerTests: XCTestCase {
    var sut: FeatureFlagsManagerInterface!
    
    override func setUpWithError() throws {
        sut = FeatureFlagsManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_feature_manager_register_features() throws {
        
        sut.register(
            flag: FeatureFlagModel(
                key: .shopFeature,
                isEnabled: true
            ),
            forKey: .shopFeature
        )

        XCTAssertTrue(sut.getRegisterdFeature(forKey: .shopFeature).isFeatureEnabled())
    }

    func test_feature_manager_register_disabled_features() throws {
        
        sut.register(
            flag: FeatureFlagModel(
                key: .shopFeature,
                isEnabled: false
            ),
            forKey: .shopFeature
        )
        
        XCTAssertFalse(sut.getRegisterdFeature(forKey: .shopFeature).isFeatureEnabled())
    }
    
    func test_get_remote_features_flags() throws {
        
        try makeJsonFeaturesData(getCorrrectJsonData()).forEach{
            sut.register(
                flag: $0,
                forKey: $0.key
            )
        }
        
        let shopFeature = sut.getRegisterdFeature(forKey: .shopFeature)
        let reviewsFeature = sut.getRegisterdFeature(forKey: .reviews)
        let projectFeature = sut.getRegisterdFeature(forKey: .project)
        
        XCTAssertTrue(shopFeature.isFeatureEnabled())
        XCTAssertTrue(reviewsFeature.isFeatureEnabled())
        XCTAssertFalse(projectFeature.isFeatureEnabled())
        
    }
    
    func test_get_remote_features_flags_with_new_feature_key_i_use_unknown() throws {
        
        try makeJsonFeaturesData(getCorrrectJsonData()).forEach{
            sut.register(
                flag: $0,
                forKey: $0.key
            )
        }
    
        let unknownKey = sut.getRegisterdFeature(forKey: .unknown)
        
        XCTAssertFalse(unknownKey.isFeatureEnabled())
        
    }
    
    func test_get_remote_features_flags_catches_decoing_error() throws {
        
        XCTAssertThrowsError(
            try makeJsonFeaturesData(getWrongJsonFormat()).forEach{
                sut.register(
                    flag: $0,
                    forKey: $0.key
                )
            })
        
    }
    
}

// MARK: Helpers
extension FeatureFlagsManagerTests {
    private func getWrongJsonFormat() -> String{
           """
               {
                 "key": "shopFeature",
                 "is_enabled": true
               }
           """
    }
    
    private func getCorrrectJsonData() -> String{
                """
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
                """
    }
    
    private func makeJsonFeaturesData(_ json: String) throws -> [FeatureFlagModel]{
        let jsonData = json.data(using: .utf8)
        
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
