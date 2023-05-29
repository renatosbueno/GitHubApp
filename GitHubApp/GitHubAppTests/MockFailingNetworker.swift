//
//  MockFailingNetworker.swift
//  GitHubAppTests
//
//  Created by Renato Bueno on 28/05/23.
//

import Foundation
@testable import GitHubApp

final class MockFailingNetworker: NSObject, NetworkerProtocol {
    
    func request<DataType>(endpoint: GitHubApp.NetworkEndpoint, type: DataType.Type, completion: @escaping (Result<DataType?, NetworkErrorType>) -> Void) where DataType : Decodable, DataType : Encodable {
        completion(.failure(.error(code: .badRequest)))
    }
    
    func requestData(endpoint: GitHubApp.NetworkEndpoint, completion: @escaping (Result<Data, GitHubApp.NetworkErrorType>) -> Void) {
        completion(.failure(.error(code: .badRequest)))
    }
    
    func cancelRequest() {
    }
}
