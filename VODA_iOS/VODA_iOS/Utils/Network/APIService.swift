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
    private let jsonDecoder = JSONDecoder()
    
    func request<C: Codable, T: TargetType>(target: T, responseType: C.Type, completion: @escaping (Result<C, Error>) -> Void) {
        let provider = MoyaProvider<T>(session: DefaultSession.sharedSession)
        
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let parsedResponse = try self.jsonDecoder.decode(responseType, from: response.data)
                    completion(.success(parsedResponse))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
