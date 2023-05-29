//
//  RepoView.swift
//  GitHubApp
//
//  Created by Renato Bueno on 27/05/23.
//

import UIKit
import UIView_Shimmer

final class RepoView: UIView, ShimmeringViewProtocol {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = theme.titleLabelFont
        label.textColor = theme.titleLabelTextColor
        
        return label
    }()
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = theme.descriptionLabelFont
        label.textColor = theme.descriptionLabelTextColor
        
        return label
    }()
    
    private lazy var centerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = theme.descriptionLabelFont
        label.textColor = theme.descriptionLabelTextColor
        
        return label
    }()
    
    private lazy var centerIconView: UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: 8, height: 8)
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = theme.iconTintColor
        
        return view
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = theme.descriptionLabelFont
        label.textColor = theme.descriptionLabelTextColor
        
        return label
    }()
    
    private lazy var rightIconView: UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: 8, height: 8)
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = theme.iconTintColor
        
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    private lazy var theme: RepoViewThemeProtocol = RepoViewDefaultTheme()
    
    var shimmeringAnimatedItems: [UIView] {
        return [titleLabel, leftLabel, centerLabel, centerIconView, rightLabel, rightIconView]
    }
    
    convenience init(theme: RepoViewThemeProtocol = RepoViewDefaultTheme()) {
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
    
    private func setupAcessibility() {
        [titleLabel, leftLabel, centerIconView, centerLabel, rightIconView, rightLabel].forEach({ $0.isAccessibilityElement = true })
        hStackView.isAccessibilityElement = false
    }
    
    private func setAcessibilityValues(dto: DTO) {
        titleLabel.accessibilityLabel = dto.title
        leftLabel.accessibilityLabel = dto.leftTitle
        centerIconView.accessibilityLabel = dto.centerTitle
        centerLabel.accessibilityLabel = dto.centerTitle
        rightIconView.accessibilityLabel = dto.rightTitle
        rightLabel.accessibilityLabel = dto.rightTitle
    }
    
    struct DTO {
        let title, leftTitle, centerTitle, rightTitle: String
        var centerIconImage, righIconImage: UIImage?
    }
    
    enum RenderType {
        case loading
        case fill(dto: DTO)
    }
    
    func render(type: RenderType) {
        switch type {
        case .loading:
            shimmeringAnimatedItems.forEach({ $0.setTemplateWithSubviews(true, animate: true, viewBackgroundColor: .darkGray) })
            
        case .fill(dto: let dto):
            shimmeringAnimatedItems.forEach({ $0.setTemplateWithSubviews(false) })
            
            titleLabel.text = dto.title
            leftLabel.text = dto.leftTitle
            centerIconView.image = dto.centerIconImage
            centerLabel.text = dto.centerTitle
            rightIconView.image = dto.righIconImage
            rightLabel.text = dto.rightTitle
            
            setAcessibilityValues(dto: dto)
        }
    }
    
}
// MARK: - ViewCodeProtocol
extension RepoView: ViewCodeProtocol {
    
    func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(hStackView)
        hStackView.addArrangedSubview(leftLabel)
        hStackView.addArrangedSubview(centerIconView)
        hStackView.addArrangedSubview(centerLabel)
        hStackView.addArrangedSubview(rightIconView)
        hStackView.addArrangedSubview(rightLabel)
    }
    
    func setupConstraints() {
        let spacing: CGFloat = theme.spacing
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
            
            hStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            hStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: theme.spacing / 2),
            hStackView.heightAnchor.constraint(equalToConstant: theme.hStackHeight),
            hStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing)
        ])
    }
    
    func setupAdditionalConfiguration() {
        setupAcessibility()
    }
}
