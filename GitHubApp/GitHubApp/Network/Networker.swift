//
//  Networker.swift
//
//

import Foundation

enum HttpMethod: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol NetworkerProtocol: AnyObject {
    func request<DataType: Codable>(endpoint: NetworkEndpoint, type: DataType.Type, completion: @escaping (Result<DataType?, NetworkErrorType>) -> Void)
    func requestData(endpoint: NetworkEndpoint, completion: @escaping (Result<Data, NetworkErrorType>) -> Void)
    func cancelRequest()
}

final class Networker: NSObject, NetworkerProtocol {
    
    private var task: URLSessionDataTask?
    private lazy var session: URLSession = {
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
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
        let endpointPath = endpoint.baseUrl + endpoint.path
        let path = endpoint.shouldMockRequest ? endpointPath + ".json" : endpointPath
        guard let url = URL(string: path) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        return urlRequest
    }
}
// MARK: - URLSessionDelegate
extension Networker: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        let urlCredential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, urlCredential)
    }
    
}
