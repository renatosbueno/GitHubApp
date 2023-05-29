//
//  HomeUserDataSource.swift
//  GitHubApp
//
//  Created by Renato Bueno on 26/05/23.
//

import UIKit

final class HomeUserDataSource: NSObject {
    
    private var dataSource: [DataSource] = []
    
    struct DataSource: Equatable {
        var id: Int
        var user: String
        var imagePath: String
        var isLoading: Bool = false
    }
    
    init(dataSource: [HomeUserDataSource.DataSource]) {
        self.dataSource = dataSource
    }
    
}
extension HomeUserDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeUserCollectionViewCell.self), for: indexPath) as? HomeUserCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = dataSource[indexPath.row]
        let dto = UserView.DTO(title: data.user, imagePath: data.imagePath)
        cell.render(id: data.id, type: data.isLoading ? .loading : .fill(dto: dto))

        return cell
    }
    
}
