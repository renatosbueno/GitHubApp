//
//  UserDetailInfoCell.swift
//  GitHubApp
//
//  Created by Renato Bueno on 27/05/23.
//

import UIKit

final class UserDetailInfoCell: UITableViewCell {
    
    private lazy var userView: UserDetailInfoView = {
        let view = UserDetailInfoView(theme: UserDetailInfoViewDefaultTheme())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) var currentId: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            userView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            userView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func render(id: Int, type: UserDetailInfoView.RenderType) {
        currentId = id
        userView.render(type: type)
    }
    
    func cancelImageDownload() {
        userView.cancelImageFetching()
    }
}
