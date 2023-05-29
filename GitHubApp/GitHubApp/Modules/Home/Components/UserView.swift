//
//  UserView.swift
//  GitHubApp
//
//  Created by Renato Bueno on 26/05/23.
//

import UIKit
import UIView_Shimmer

final class UserView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = theme.spacing
        
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = theme.titleLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: self.frame.width / 2, height: self.frame.width / 2)
        let view = UIImageView(frame: rect)
        view.contentMode = theme.imageContentMode
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var theme: UserViewThemeProtocol = UserViewDefaultTheme()
    
    var shimmeringAnimatedItems: [UIView] {
        return [titleLabel, imageView]
    }
    
    convenience init(theme: UserViewThemeProtocol = UserViewDefaultTheme()) {
        self.init(frame: .zero)
        self.theme = theme
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    private func setupAcessibility() {
        stackView.isAccessibilityElement = false
        [imageView, titleLabel].forEach({ $0.isAccessibilityElement = true })
    }
    
    private func setAcessibilityValues(dto: DTO) {
        titleLabel.accessibilityLabel = dto.title
        imageView.accessibilityLabel = dto.imageDescription
    }
    
    enum RenderType {
        case loading
        case fill(dto: DTO)
    }
    
    struct DTO {
        let title, imagePath: String
        var imageDescription: String?
    }
    
    func render(type: RenderType) {
        switch type {
        case .fill(dto: let dto):
            imageView.fetchImage(path: dto.imagePath)
            titleLabel.text = dto.title
            shimmeringAnimatedItems.forEach({ $0.setTemplateWithSubviews(false) })
            
            setAcessibilityValues(dto: dto)
        case .loading:
            shimmeringAnimatedItems.forEach({ $0.setTemplateWithSubviews(true, animate: true, viewBackgroundColor: .darkGray) })
        }
    }
    
    func cancelImageDownload() {
        imageView.cancelImageFetching()
        imageView.image = UIImage()
    }
    
}
extension UserView: ViewCodeProtocol {
    
    func buildViewHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setupConstraints() {
        let constant: CGFloat = theme.spacing
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant),
            
            titleLabel.heightAnchor.constraint(equalToConstant: theme.titleLabelHeight)
        ])
    }
    
    func setupAdditionalConfiguration() {
        setupAcessibility()
    }
}
