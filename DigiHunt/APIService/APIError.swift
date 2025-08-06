//
//  APIError.swift
//  DigiHunt
//
//  Created by Sahil ChowKekar on 3/3/25.
//

import Foundation

enum APIError: Error {
    case invalidURLError
    case parsingError
    case noDataError
    case responsError(Int)
}
