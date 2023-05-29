//
//  Themes.swift
//  GitHubApp
//
//  Created by Renato Bueno on 28/05/23.
//

import UIKit

// MARK: - UserDetailInfoViewThemeProtocol
protocol UserDetailInfoViewThemeProtocol: AnyObject {
    var vStackViewSpacing: CGFloat { get }
    var spacing: CGFloat { get }
    var hStackHeight: CGFloat { get }
    var leftLabelFont: UIFont { get }
    var leftLabelTextColor: UIColor { get }
    var rightLabelFont: UIFont { get }
    var rightLabelTextColor: UIColor { get }
}

// MARK: - UserDetailInfoViewDefaultTheme
final class UserDetailInfoViewDefaultTheme: UserDetailInfoViewThemeProtocol {
    
    var vStackViewSpacing: CGFloat {
        return 6
    }
    
    var spacing: CGFloat {
        return 16
    }
    
    var hStackHeight: CGFloat {
        return 22
    }
    
    var leftLabelFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    var leftLabelTextColor: UIColor {
        return .darkGray
    }
    
    var rightLabelFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    var rightLabelTextColor: UIColor {
        return .darkGray
    }
    
}

// MARK: - RepoViewThemeProtocol
protocol RepoViewThemeProtocol: AnyObject {
    var titleLabelFont: UIFont { get }
    var titleLabelTextColor: UIColor { get }
    var descriptionLabelFont: UIFont { get }
    var descriptionLabelTextColor: UIColor { get }
    var spacing: CGFloat { get }
    var hStackHeight: CGFloat { get }
    var iconTintColor: UIColor { get }
}

// MARK: - RepoViewDefaultTheme

final class RepoViewDefaultTheme: RepoViewThemeProtocol {
    
    var titleLabelFont: UIFont {
        return .systemFont(ofSize: 14, weight: .semibold)
    }
    
    var titleLabelTextColor: UIColor {
        return .black
    }
    
    var descriptionLabelFont: UIFont {
        return .systemFont(ofSize: 14, weight: .semibold)
    }
    
    var descriptionLabelTextColor: UIColor {
        return .black
    }
    
    var spacing: CGFloat {
        return 16
    }
    
    var hStackHeight: CGFloat {
        return 22
    }
    
    var iconTintColor: UIColor {
        return .darkGray
    }
}
