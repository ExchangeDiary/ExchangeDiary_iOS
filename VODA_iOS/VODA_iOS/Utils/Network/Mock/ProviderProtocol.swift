//
//  ProviderProtocol.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/12/14.
//

import Foundation

import Moya

protocol ProviderProtocol: AnyObject {
    associatedtype T: TargetType
    
    var provider: MoyaProvider<MultiTarget> { get }
    init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((T) -> Endpoint)?)
}

extension ProviderProtocol {
    static func consProvider(
        _ isStub: Bool = false,
        _ sampleStatusCode: Int = 200,
        _ customEndpointClosure: ((T) -> Endpoint)? = nil) -> MoyaProvider<T> {
            
            if isStub == false {
                return MoyaProvider<T>()
            } else {
                let endPointClosure = { (target: T) -> Endpoint in
                    let sampleResponseClosure: () -> EndpointSampleResponse = {
                        EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                    }
                    
                    return Endpoint(
                        url: URL(target: target).absoluteString,
                        sampleResponseClosure: sampleResponseClosure,
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers
                    )
                }
                return MoyaProvider<T>(
                    endpointClosure: customEndpointClosure ?? endPointClosure,
                    stubClosure: MoyaProvider.immediatelyStub
                )
            }
        }
}

extension ProviderProtocol {
    static func request<T: Codable, API: TargetType>(_ target: API, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let provider = MoyaProvider<API>(session: DefaultSession.sharedSession)
        provider.request(target) { result in
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
