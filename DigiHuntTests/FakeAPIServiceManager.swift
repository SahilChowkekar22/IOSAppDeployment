//
//  FakeAPIServiceManager.swift
//  DigiHuntTests
//
//  Created by Sahil ChowKekar on 3/4/25.
//

import Foundation
@testable import DigiHunt
import Combine

class FakeAPIServiceManager: APIService {
    var testPath = ""
    
    func fetchDataFromURL<T>(url: String, modelType: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        let bundle = Bundle(for: FakeAPIServiceManager.self)
        let urlObj = bundle.url(forResource: testPath, withExtension: "json")
        
        guard let urlObj = urlObj else {
            return Fail(error: APIError.invalidURLError).eraseToAnyPublisher()
        }
        
        do{
           let data = try Data(contentsOf: urlObj)
           let parsedData = try JSONDecoder().decode(modelType, from: data)
            
            return Just(parsedData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        catch{
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        }
        
    }
    
    
}
