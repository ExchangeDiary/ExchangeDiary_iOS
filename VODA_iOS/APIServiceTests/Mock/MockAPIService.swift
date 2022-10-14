//
//  MockAPIService.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/12/14.
//

import Foundation

import Moya

class MockAPIService {
    let customEndpointClosure = { (target: MultiTarget) -> Endpoint in
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    func request<T: Codable, API: TargetType>(_ target: API, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let provider = MoyaProvider<MultiTarget>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)

        provider.request(MultiTarget(target)) { result in
            switch result {
            case let .success(response):
                do {
                    let parsedResponse = try JSONDecoder().decode(responseType, from: response.data)
                    completion(.success(parsedResponse))
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
