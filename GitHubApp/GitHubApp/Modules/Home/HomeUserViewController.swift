//
//  HomeUserViewController.swift
//  GitHubApp
//
//  Created by Renato Bueno on 25/05/23.
//

import UIKit

protocol ViewCodeProtocol {
    func setupView()
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
}
extension ViewCodeProtocol {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}

final class HomeUserViewController: UIViewController {
    
    // MARK: - VIPER Properties
    
    private let presenter: HomeUserPresenterInputProtocol

    // MARK: - Internal Properties
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar(frame: .zero)
        view.searchBarStyle = .default
        view.placeholder = Strings.SearchBar.placeholder
        view.isTranslucent = false
        view.backgroundImage = UIImage()
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.allowsSelection = true
        collection.dataSource = dataSource
        collection.delegate = self
        
        return collection
    }()
    
    private lazy var dataSource = HomeUserDataSource(dataSource: [])

    // MARK: - Private Properties

    // MARK: - Inits
    
    init(
        presenter: HomeUserPresenterInputProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCell()
        presenter.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarAppearance()
    }
    
    // MARK: - Internal Methods
    
    // MARK: - Private Methods
    
    private func toggleLoadingDataSource() {
        self.dataSource = HomeUserDataSource(dataSource: Array(repeating: HomeUserDataSource.DataSource(id: 0, user: String(), imagePath: String(), isLoading: true), count: 6))
    }
    
    private func setupNavigationBarAppearance() {
        let navigation = self.navigationController?.navigationBar
        navigation?.tintColor = UIColor.black
        navigation?.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    private func registerCell() {
        collectionView.register(HomeUserCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HomeUserCollectionViewCell.self))
    }
    
    // MARK: - Actions
}

// MARK: - View Code
extension HomeUserViewController: ViewCodeProtocol {
    func buildViewHierarchy() {
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupAdditionalConfiguration() {
        
    }
}
// MARK: - UISearchBarDelegate
extension HomeUserViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterUsers(searchText: searchText)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension HomeUserViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeUserCollectionViewCell, let selectedId = cell.currentId else {
            return
        }
        presenter.didSelectItem(id: selectedId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let width = (view.frame.size.width - spacing) / 2
        return CGSize(width: width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets: CGFloat = 2
        return UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let userCell = cell as? HomeUserCollectionViewCell else {
            return
        }
        userCell.cancelImageDownload()
    }
}

// MARK: - Presenter Output Protocol
extension HomeUserViewController: HomeUserPresenterOutputProtocol {
    
    func didFinishRequest(dataSource: [HomeUserDataSource.DataSource]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.dataSource = HomeUserDataSource(dataSource: dataSource)
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    func toggleLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.toggleLoadingDataSource()
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    func shouldShowError(message: String, actionTitle: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.showAlert(title: message, message: String(), actionTitle: actionTitle) { _ in
                self.presenter.fetchData()
            }
        }
    }
}
