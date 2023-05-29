//
//  MockNetworker.swift
//  GitHubAppTests
//
//  Created by Renato Bueno on 28/05/23.
//

import Foundation
@testable import GitHubApp

final class MockNetworker: NSObject, NetworkerProtocol {
    
    private var task: URLSessionDataTask?
    private lazy var session: URLSession = {
        return URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    }()
    
    func request<DataType: Codable>(endpoint: NetworkEndpoint, type: DataType.Type, completion: @escaping (Result<DataType?, NetworkErrorType>) -> Void) {
        guard let urlRequest = setupUrlRequest(endpoint: endpoint) else {
            completion(.failure(.error(code: .unkown)))
            return
        }
        task = session.dataTask(with: urlRequest) { data, response, error in
            if let urlResponse = response as? HTTPURLResponse, error != nil {
                let error = self.handleErrorResponse(response: urlResponse)
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(.error(code: .decodingError)))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let object = try? decoder.decode(DataType.self, from: data)
            completion(.success(object))
        }
        task?.resume()
    }
    
    func requestData(endpoint: NetworkEndpoint, completion: @escaping (Result<Data, NetworkErrorType>) -> Void) {
        guard let urlRequest = setupUrlRequest(endpoint: endpoint) else {
            completion(.failure(.error(code: .unkown)))
            return
        }
        task = session.dataTask(with: urlRequest) { data, response, error in
            if let urlResponse = response as? HTTPURLResponse, error != nil {
                let error = self.handleErrorResponse(response: urlResponse)
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(.error(code: .decodingError)))
                return
            }
            completion(.success(data))
        }
        task?.resume()
    }
    
    func cancelRequest() {
        task?.cancel()
    }
    
    private func handleErrorResponse(response: HTTPURLResponse) -> NetworkErrorType {
        let errorType = NetworkErrorStatusCode(rawValue: response.statusCode)
        let error: NetworkErrorType = {
            guard let errorCode = errorType else {
                return .other(statusCode: response.statusCode)
            }
            return .error(code: errorCode)
        }()
        return error
    }
    
    private func decodeObject<T: Codable>(data: Data, type: Codable) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(T.self, from: data)
    }
    
    private func setupUrlRequest(endpoint: NetworkEndpoint) -> URLRequest? {
        let baseUrl = Bundle.main.bundleURL.absoluteString
        let endpointPath = baseUrl + endpoint.path.replacingOccurrences(of: "/", with: "-")
        let path = endpointPath + ".json"
        guard let url = URL(string: path) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        return urlRequest
    }
}
