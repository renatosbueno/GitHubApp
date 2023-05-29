//
//  UserDetailInfoView.swift
//  GitHubApp
//
//  Created by Renato Bueno on 27/05/23.
//

import UIKit
import UIView_Shimmer

final class UserDetailInfoView: UIView, ShimmeringViewProtocol {
    
    private lazy var userView: UserView = {
        let view = UserView(theme: UserViewDetailTheme())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = theme.spacing
        
        return stack
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = theme.leftLabelFont
        label.textColor = theme.leftLabelTextColor
        
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = theme.rightLabelFont
        label.textColor = theme.rightLabelTextColor
        
        return label
    }()
    
    private lazy var theme: UserDetailInfoViewThemeProtocol = UserDetailInfoViewDefaultTheme()
    
    var shimmeringAnimatedItems: [UIView] {
        [leftLabel, rightLabel, userView]
    }
    
    struct DTO {
        let title: String
        let subtitle: String
        let userDTO: UserView.DTO
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
            leftLabel.text = dto.title
            rightLabel.text = dto.subtitle
            
            userView.render(type: .fill(dto: dto.userDTO))
            
            shimmeringAnimatedItems.forEach({ $0.setTemplateWithSubviews(false) })
            
            setAcessibilityValues(dto: dto)
        }
    }
    
    func cancelImageFetching() {
        userView.cancelImageDownload()
    }
    
    convenience init(theme: UserDetailInfoViewThemeProtocol = UserDetailInfoViewDefaultTheme()) {
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
        [leftLabel, rightLabel, userView].forEach({ $0.isAccessibilityElement = true })
        [vStackView, hStackView].forEach({ $0.isAccessibilityElement = false })
    }
    
    private func setAcessibilityValues(dto: DTO) {
        leftLabel.accessibilityLabel = dto.title
        rightLabel.accessibilityLabel = dto.subtitle
    }
}
// MARK: - ViewCodeProtocol
extension UserDetailInfoView: ViewCodeProtocol {
    
    func buildViewHierarchy() {
        addSubview(vStackView)
        addSubview(hStackView)
        hStackView.addArrangedSubview(leftLabel)
        hStackView.addArrangedSubview(rightLabel)
        vStackView.addArrangedSubview(userView)
        vStackView.addArrangedSubview(hStackView)
    }
    
    func setupConstraints() {
        let spacing: CGFloat = theme.spacing
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            vStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            vStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
            vStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing),
            
            hStackView.heightAnchor.constraint(equalToConstant: theme.hStackHeight)
        ])
    }
    
    func setupAdditionalConfiguration() {
        setupAcessibility()
    }
}
