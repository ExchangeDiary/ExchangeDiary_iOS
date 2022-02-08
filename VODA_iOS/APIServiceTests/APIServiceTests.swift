//
//  APIServiceTests.swift
//  APIServiceTests
//
//  Created by 전소영 on 2021/12/14.
//

import XCTest

@testable import VODA_iOS

class APIServiceTests: XCTestCase {
    var sut: MockAPIService!
    
    override func setUpWithError() throws {
        sut = MockAPIService(isStub: true)
    }
    
    func testVodaAPI() throws {
        let expectation = XCTestExpectation()
        
        let expectedStoryDetailData = VodaAPI.testGetStoryDetail(index: 1).sampleData
        
        guard let storyDetailData = try? JSONDecoder().decode(StoryDataResponse.self, from: expectedStoryDetailData) else {
            return
        }
        print("storyDetailData: \(storyDetailData)")
       
        sut.testGetStoryDetail(index: 1) { response in
            guard let storyDataResponse = try? response.get() else {
                return
            }
            print("storyDataResponse: \(storyDataResponse)")
            XCTAssertEqual(storyDetailData.storyTitle, storyDataResponse.storyTitle)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testExample() throws {

    }
}
