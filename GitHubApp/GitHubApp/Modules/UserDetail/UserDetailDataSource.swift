//
//  UserDetailDataSource.swift
//  GitHubApp
//
//  Created by Renato Bueno on 27/05/23.
//

import UIKit

final class UserDetailDataSource: NSObject {
    
    typealias DataSource = AgroupedUserDetailData
    private var dataSource: DataSource?
    private var isLoading: Bool = false
    private(set) var cells: [[CellType]] = []
    
    init(dataSource: DataSource, isLoading: Bool) {
        self.dataSource = dataSource
        self.isLoading = isLoading
    }
    
    enum CellType {
        case user(dto: UserDetailInfo)
        case repo(dto: UserRepoData)
        
        var cellHeight: CGFloat {
            switch self {
            case .user:
                return 260
            case .repo:
                return 100
            }
        }
    }
    
    func setupCells() {
        guard let dataSource = dataSource else {
            return
        }
        let repoCells: [CellType] = dataSource.userRepos.compactMap({ .repo(dto: $0) })
        self.cells = [[.user(dto: dataSource.userDetail)], repoCells]
    }
}
// MARK: - UITableViewDataSource
extension UserDetailDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.section][indexPath.row] {
        case .user(dto: let dto):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailInfoCell.self), for: indexPath) as? UserDetailInfoCell else {
                return UITableViewCell()
            }
            let locationValue = dto.location ?? String()
            let followersValue = dto.followers ?? 0
            let viewDto = UserDetailInfoView.DTO(title: "\(Strings.UserDetailInfo.locationTitle) \(locationValue)",
                                             subtitle: "\(Strings.UserDetailInfo.followersTitle) \(followersValue)",
                                             userDTO: UserView.DTO(title: dto.name ?? String(), imagePath: dto.avatarUrl))
            cell.render(id: dto.id, type: isLoading ? .loading : .fill(dto: viewDto))
            
            return cell
        case .repo(dto: let dto):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepoCell.self), for: indexPath) as? RepoCell else {
                return UITableViewCell()
            }
            let repoDto = RepoView.DTO(title: dto.name,
                                       leftTitle: dto.language ?? "--",
                                       centerTitle: "\(dto.stargazersCount)",
                                       rightTitle: "\(dto.forksCount)",
                                       centerIconImage: UIImage(systemName: Strings.SFSymbolsStrings.star),
                                       righIconImage: UIImage(systemName: Strings.SFSymbolsStrings.fork))
            cell.render(id: dto.id, type: isLoading ? .loading : .fill(dto: repoDto))
            
            return cell
        }
    }
}
