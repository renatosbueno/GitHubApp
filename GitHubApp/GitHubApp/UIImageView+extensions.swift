//
//  UIImageView+extensions.swift
//  GitHubApp
//
//  Created by Renato Bueno on 26/05/23.
//

import UIKit
import UIView_Shimmer

extension UIImageView {
    
    func fetchImage(path: String) {
        ImageDownloader().fetchImage(path: path) { result in
            guard case .success(let data) = result else {
                return
            }
            DispatchQueue.main.async {
                self.setTemplateWithSubviews(false)
                self.image = UIImage(data: data)
            }
        }
    }
    
    func cancelImageFetching() {
        ImageDownloader().cancelDownload()
    }
    
}
extension UIImageView: ShimmeringViewProtocol { }

extension UIViewController {
    
    func showAlert(title: String, message: String, actionTitle: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Voltar", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
}
