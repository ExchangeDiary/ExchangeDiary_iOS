//
//  APIServiceTests.swift
//  APIServiceTests
//
//  Created by 전소영 on 2021/12/14.
//

import XCTest

@testable import VODA_iOS

class APIServiceTests: XCTestCase {
    func testMockAPIService() {
        // Given
        let sut = MockAPIService()
        
        // When
        sut.request(VodaAPI.testGetStoryDetail(index: 1), responseType: StoryDataResponse.self) { response in
            guard let storyDataResponse = try? response.get() else {
                return
            }
            
            // Then
            XCTAssertEqual(storyDataResponse.storyWriteDate, "210102")
            XCTAssertEqual(storyDataResponse.storyLocation, "home")
            XCTAssertEqual(storyDataResponse.storyContentsText, "testText")
            XCTAssertEqual(storyDataResponse.storyAudioTitle, "testAudioTitle")
            XCTAssertEqual(storyDataResponse.storyAudioFileName, "testFileName")
            XCTAssertEqual(storyDataResponse.storyAudioPitch, 0.5)
            XCTAssertEqual(storyDataResponse.storyAudioUrl, "https://github.com/ExchangeDiary/ExchangeDiary_iOS")
            XCTAssertEqual(storyDataResponse.storyPhotoUrl, "https://github.com/ExchangeDiary/ExchangeDiary_iOS")
            XCTAssertEqual(storyDataResponse.storyTemplete, 1)
        }
    }
}
