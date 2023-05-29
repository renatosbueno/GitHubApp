//
//  HomeThemes.swift
//  GitHubApp
//
//  Created by Renato Bueno on 28/05/23.
//

import UIKit

// MARK: - UserViewThemeProtocol
protocol UserViewThemeProtocol: AnyObject {
    var stackSpacing: CGFloat { get }
    var titleLabelFont: UIFont { get }
    var imageContentMode: UIView.ContentMode { get }
    var spacing: CGFloat { get }
    var titleLabelHeight: CGFloat { get }
}

// MARK: - UserViewDetailTheme
final class UserViewDetailTheme: UserViewThemeProtocol {
    
    var stackSpacing: CGFloat {
        return 8
    }
    
    var titleLabelFont: UIFont {
        return .systemFont(ofSize: 16, weight: .semibold)
    }
    
    var imageContentMode: UIView.ContentMode {
        return .scaleAspectFill
    }
    
    var spacing: CGFloat {
        return 4
    }
    
    var titleLabelHeight: CGFloat {
        return 22
    }
}

// MARK: - UserViewDefaultTheme
final class UserViewDefaultTheme: UserViewThemeProtocol {
    
    var stackSpacing: CGFloat {
        return 8
    }
    
    var titleLabelFont: UIFont {
        return .systemFont(ofSize: 16, weight: .semibold)
    }
    
    var imageContentMode: UIView.ContentMode {
        return .scaleAspectFit
    }
    
    var spacing: CGFloat {
        return 4
    }
    
    var titleLabelHeight: CGFloat {
        return 22
    }
    
}
