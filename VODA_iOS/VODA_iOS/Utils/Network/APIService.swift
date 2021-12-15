//
//  APIService.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/12/09.
//

import Foundation

import Moya

class APIService {
    static let shared = APIService()
    
    func request<T: Codable, API: TargetType>(_ target: API, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
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
