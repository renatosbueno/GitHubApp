//
//  HomeUserCollectionViewCell.swift
//  GitHubApp
//
//  Created by Renato Bueno on 26/05/23.
//

import UIKit

final class HomeUserCollectionViewCell: UICollectionViewCell {
    
    private(set) var currentId: Int?
    
    private lazy var userView: UserView = {
        let view = UserView(theme: UserViewDefaultTheme())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(userView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageDownload()
    }
    
    func render(id: Int, type: UserView.RenderType) {
        currentId = id
        userView.render(type: type)
    }
    
    func cancelImageDownload() {
        userView.cancelImageDownload()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            userView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            userView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
