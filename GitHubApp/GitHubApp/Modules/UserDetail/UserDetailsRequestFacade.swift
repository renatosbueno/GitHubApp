//
//  UserDetailsRequestFacade.swift
//  GitHubApp
//
//  Created by Renato Bueno on 27/05/23.
//

import Foundation

final class UserDetailsRequestFacade {
    
    // MARK: - Private Properties
    private let requestable: NetworkerProtocol
    private let username: String
    
    init(requestable: NetworkerProtocol, username: String) {
        self.requestable = requestable
        self.username = username
    }
    
    func fetch(completion: @escaping (Result<AgroupedUserDetailData?, NetworkErrorType>) -> Void) {
        fetchUserInfo(completion: completion)
    }
    
    private func fetchUserInfo(completion: @escaping (Result<AgroupedUserDetailData?, NetworkErrorType>) -> Void) {
        let userEndpoint = UserDetailedInfoEndpoint(username: username)
        requestable.request(endpoint: userEndpoint, type: UserDetailInfo.self) { [weak self] result in
            switch result {
            case .success(let data):
                guard let userDetail = data else {
                    completion(.failure(.error(code: .unkown)))
                    return
                }
                self?.fetchUserRepos(userDetail: userDetail, completion: completion)
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    private func fetchUserRepos(userDetail: UserDetailInfo, completion: @escaping (Result<AgroupedUserDetailData?, NetworkErrorType>) -> Void) {
        let reposEndpoint = UserReposEndpoint(username: username)
        requestable.request(endpoint: reposEndpoint, type: [UserRepoData].self) { result in
            guard case .success(let data) = result else {
                completion(.success(AgroupedUserDetailData(userDetail: userDetail)))
                return
            }
            let object = AgroupedUserDetailData(userDetail: userDetail, userRepos: data ?? [])
            completion(.success(object))
        }
    }
    
}
// MARK: - UserDetailedInfoEndpoint
struct UserDetailedInfoEndpoint: NetworkEndpoint {
    
    let username: String
    
    var path: String {
        return "users/\(username)"
    }
    
}

// MARK: - UserReposEndpoint
struct UserReposEndpoint: NetworkEndpoint {
    
    let username: String
    
    var path: String {
        return "users/\(username)/repos"
    }
    
}
