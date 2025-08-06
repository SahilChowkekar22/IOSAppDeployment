//
//  APIServiceManager.swift
//  DigiHunt
//
//  Created by Sahil ChowKekar on 3/3/25.
//

import Combine
import Foundation

protocol APIService {
    func fetchDataFromURL<T: Decodable>(url: String, modelType: T.Type)
        -> AnyPublisher<T, Error>
}

class APIServiceManager {
    let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

}

extension APIServiceManager: APIService {
    func fetchDataFromURL<T: Decodable>(url: String, modelType: T.Type)
        -> AnyPublisher<T, Error> where T: Decodable
    {
        guard let urlObj = URL(string: url) else {
            return Fail(error: APIError.invalidURLError).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: urlObj)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse
                else {
                    throw APIError.noDataError
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.responsError(httpResponse.statusCode)
                }
                return result.data
            }
            .decode(type: modelType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
