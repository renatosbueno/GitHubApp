//
//  RepoCell.swift
//  GitHubApp
//
//  Created by Renato Bueno on 27/05/23.
//

import UIKit

final class RepoCell: UITableViewCell {
    
    private lazy var repoView: RepoView = {
        let view = RepoView(theme: RepoViewDefaultTheme())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) var currentId: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(repoView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            repoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            repoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            repoView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            repoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func render(id: Int, type: RepoView.RenderType) {
        currentId = id
        repoView.render(type: type)
    }
}
