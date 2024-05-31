import XCTest
@testable import swift


/// new feature is enabled, has a view
/// new feature is disabled, has default coming soon view

final class FeatureFlagVMTests: XCTestCase {
    var sut: FeatureFlagClient!
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_new_feature_is_enabled_returns_enabled() throws {
        sut = ShopFeatureViewModel()
        
        XCTAssertTrue(sut.isFeatureEnabled())
    }
    
    func test_new_feature_is_disabled_returns_disabled() throws {
        sut = ProjectViewModel()
        XCTAssertFalse(sut.isFeatureEnabled())
    }

}

