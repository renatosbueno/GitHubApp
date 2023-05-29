//
//  ImageDownloader.swift
//  GitHubApp
//
//  Created by Renato Bueno on 26/05/23.
//

import UIKit

final class ImageDownloader {
    
    private var requestable: NetworkerProtocol = Networker()
    
    init(requestable: NetworkerProtocol = Networker()) {
        self.requestable = requestable
    }
    
    func fetchImage(path: String, completion: @escaping (Result<Data, NetworkErrorType>) -> Void) {
        let endpoint = ImageDownloaderEndpoint(path: path)
        requestable.requestData(endpoint: endpoint) { result in
            completion(result)
        }
    }
    
    func cancelDownload() {
        requestable.cancelRequest()
    }
    
    struct ImageDownloaderEndpoint: NetworkEndpoint {
        
        var baseUrl: String {
            return ""
        }
        
        var headers: [String: String] {
            return ["Content-Type": "image/jpeg"]
        }
        
        var path: String
        
        init(path: String) {
            self.path = path
        }
    }
}
