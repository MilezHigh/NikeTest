//
//  NikeTest1Tests.swift
//  NikeTest1Tests
//
//  Created by Miles Fishman on 3/6/21.
//

import XCTest

@testable import NikeTest1

class NikeTest1Tests: XCTestCase {
    
    let api = API.instance
    
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    // MARK: - End to End Unit Tests
    
    // Feature Specific Testing
    func testRSSFeedValidAPIResponse() {
        let promise = expectation(description: "Valid Response")
        api.fetchRSSFeed() { (result) in
            switch result {
            case .success(let results):
                XCTAssertGreaterThanOrEqual(results.count, 0)
                
            case .failure(let error):
                XCTFail("XCTest Failure: " + error.message)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    // Utility Testing
    func testValidImageURLData() {
        let urlString = "https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/f5/7a/9e/f57a9e6a-31c8-0784-dfbd-4a0120bfd4af/21UMGIM17517.rgb.jpg/200x200bb.png"
        verifyLiveDataReturned(from: urlString)
    }
    
    func testInvalidImageURLData() {
        let invalidUrlString = "https://is2-ssl.mzstatic.com/image/x200bb.png"
        verifyLiveDataReturned(from: invalidUrlString, isInvalid: true)
    }
}

// MARK: - End to End Unit Test Helpers
private extension NikeTest1Tests {
    
    func verifyLiveDataReturned(from urlString: String, isInvalid: Bool = false) {
        let promise = expectation(description: "Valid Image URL")
        api.fetchImageData(from: urlString, { (result) in
            switch result {
            case .success(let data):
                XCTAssert(data != nil)
                
            case .failure(let error):
                let errorString = "Test Error: " + error.message
                !isInvalid ? XCTFail(errorString) : XCTAssert(isInvalid, errorString)
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
    }
}
