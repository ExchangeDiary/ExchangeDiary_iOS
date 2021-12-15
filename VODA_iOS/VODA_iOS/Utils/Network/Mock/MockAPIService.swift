//
//  MockAPIService.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/12/14.
//

import Foundation

import Moya

class MockAPIService: ProviderProtocol {
    var provider: MoyaProvider<MultiTarget>
    
    typealias T = MultiTarget
    
    required init(isStub: Bool = false, sampleStatusCode: Int = 200, customEndpointClosure: ((T) -> Endpoint)? = nil) {
        provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
    }
    
    func testGetStoryDetail(index: Int, completion: @escaping (Result<StoryDataResponse, Error>) -> Void) {
        Self.request(VodaAPI.testGetStoryDetail(index: index), responseType: StoryDataResponse.self, completion: completion)
    }
}
