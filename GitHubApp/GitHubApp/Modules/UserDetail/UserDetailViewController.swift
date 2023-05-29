
import UIKit

final class UserDetailViewController: UIViewController {
    
    // MARK: - VIPER Properties
    
    private let presenter: UserDetailPresenterInputProtocol

    // MARK: - Internal Properties

    // MARK: - Private Properties
    
    private var dataSource: UserDetailDataSource?
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = dataSource
        
        return table
    }()

    // MARK: - Inits
    
    init(
        presenter: UserDetailPresenterInputProtocol
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
        registerCells()
        presenter.loadData()
    }
    
    // MARK: - Internal Methods
    
    // MARK: - Private Methods
    
    private func toggleLoadingDataSource() {
        dataSource = UserDetailDataSource(dataSource: UserDetailDataSource.DataSource(userDetail: UserDetailInfo(avatarUrl: String(), login: String(), id: 0), userRepos: Array(repeating: UserRepoData(id: 0, forksCount: 0, stargazersCount: 0, name: String()), count: 3)), isLoading: true)
    }
    
    private func registerCells() {
        tableView.register(UserDetailInfoCell.self, forCellReuseIdentifier: String(describing: UserDetailInfoCell.self))
        tableView.register(RepoCell.self, forCellReuseIdentifier: String(describing: RepoCell.self))
    }
    
    // MARK: - Actions
}

// MARK: - View Code
extension UserDetailViewController: ViewCodeProtocol {
    func buildViewHierarchy() {
        self.view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupAdditionalConfiguration() {
    }
}

// MARK: - Presenter Output Protocol
extension UserDetailViewController: UserDetailPresenterOutputProtocol {
    func toggleLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.toggleLoadingDataSource()
            self.tableView.dataSource = self.dataSource
            self.dataSource?.setupCells()
            self.tableView.reloadData()
        }
    }
    
    func didFinishWithSuccess(dataSource: UserDetailDataSource.DataSource) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.dataSource = UserDetailDataSource(dataSource: dataSource, isLoading: false)
            self.tableView.dataSource = self.dataSource
            self.dataSource?.setupCells()
            self.title = self.presenter.getNavigationTitle()
            self.tableView.reloadData()
        }
    }
    
    func shouldShowError(message: String, actionTitle: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.showAlert(title: message, message: String(), actionTitle: actionTitle) { _ in
                self.presenter.loadData()
            }
        }
    }
}
// MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource?.cells[indexPath.section][indexPath.row].cellHeight ?? 120
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let userCell = cell as? UserDetailInfoCell else {
            return
        }
        userCell.cancelImageDownload()
    }
}
