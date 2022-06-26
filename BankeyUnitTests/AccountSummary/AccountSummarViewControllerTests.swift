//
//  AccountSummarViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Enes Sirkecioğlu on 12.06.2022.
//

import Foundation
import XCTest

@testable import Bankey

class AccountSummarViewControllerTests: XCTestCase {
    var vc: AccountSummaryViewController!
    var mockManager: MockProfileManager!
    
    class MockProfileManager: ProfileManageable {
        var profile: Profile?
        var error: NetworkError?
        
        func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
            completion(.success(profile!))
        }
    }
    
    override func setUp() {
        super.setUp()
        vc = AccountSummaryViewController()
        
        mockManager = MockProfileManager()
        vc.profileManager = mockManager
    }
    
    func testTitleAndMessageForServerError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(for: .serverError)
        XCTAssertEqual(titleAndMessage.0, "Server Error")
        XCTAssertEqual(titleAndMessage.1, "Please check your network connectivity and try again.")
    }
    
    func testTitleAndMessageForDecodingError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(for: .decodingError)
        XCTAssertEqual(titleAndMessage.0, "Decoding Error")
        XCTAssertEqual(titleAndMessage.1, "We could not process your request. Please try again.")
    }
    
    func testAlertForServerError() throws {
        mockManager.error = .serverError
        vc.forceFetchProfile()
        
        XCTAssertEqual("Server Error", vc.errorAlert.title)
        XCTAssertEqual("Please check your network connectivity and try again.", vc.errorAlert.message)
    }
    
    func testAlertForDecodingError() throws {
        mockManager.error = .decodingError
        vc.forceFetchProfile()
        
        XCTAssertEqual("Decoding Error", vc.errorAlert.title)
        XCTAssertEqual("We could not process your request. Please try again.", vc.errorAlert.message)
    }
}
