import UIKit

final class RegionListViewController: UIViewController,
                                      RegionDetailsViewControllerDelegate,
                                      RegionListViewDelegate {
    private enum State {
        case loading
        case presenting(RegionList)
        case failed(NetworkError)
    }
    
    private let networkManager: NetworkManager
    private let imageProvider: ImageProviding
    private let regionListManager: RegionListManager
    
    private let errorDisplayer: ErrorDisplayable
    private let loadingDisplayer: LoadingDisplayable
    
    private let regionListView = RegionListView()
    
    init(
        regionListManager: RegionListManager,
        imageProvider: ImageProviding,
        networkManager: NetworkManager,
        errorDisplayer: ErrorDisplayable,
        loadingDisplayer: LoadingDisplayable
    ) {
        self.regionListManager = regionListManager
        self.imageProvider = imageProvider
        self.errorDisplayer = errorDisplayer
        self.loadingDisplayer = loadingDisplayer
        self.networkManager = networkManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.appBackground
        title = "Регионы"
        navigationController?.navigationBar.prefersLargeTitles = true
        showRegionList()
    }
    
    private func showRegionList() {
        render(.loading)
        networkManager.fetchRegionList { result in
            switch result {
            case let .success(regionList):
                self.regionListManager.threadSafeRegionList = regionList
                self.render(
                    .presenting(self.regionListManager.threadSafeRegionList)
                )
            case let .failure(error):
                self.render(.failed(error))
            }
        }
    }
    
    private func render(_ state: State) {
        switch state {
        case .loading:
            loadingDisplayer.showLoading(in: self)
        case let .presenting(regionList):
            loadingDisplayer.hideLoading()
            setUpProductListView()
            regionListView.display(regionList)
        case let .failed(error):
            loadingDisplayer.hideLoading()
            errorDisplayer.presentAlert(with: error, in: self) { [weak self] in
                guard let self else { return }
                self.showRegionList()
            }
        }
    }
    
    private func setUpProductListView() {
        regionListView.delegate = self
        regionListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(regionListView)
        NSLayoutConstraint.activate([
            regionListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            regionListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            regionListView.topAnchor.constraint(equalTo: view.topAnchor),
            regionListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - RegionListViewDelegate
extension RegionListViewController {
    func didSelect(_ regionDetails: RegionDetails) {
        let regionDetailsViewController = RegionDetailsViewController(
            regionDetails: regionDetails,
            imageProvider: imageProvider
        )
        regionDetailsViewController.configure(with: self)
        
        navigationController?.pushViewController(
            regionDetailsViewController,
            animated: true
        )
    }
    
    func didReact(on regionDetails: RegionDetails) {
        regionListManager.didReact(on: regionDetails)
        render(.presenting(regionListManager.threadSafeRegionList))
    }
}

// MARK: - RegionDetailsViewControllerDelegate
extension RegionListViewController {
    func didUpdateImages(on regionDetails: RegionDetails) {
        regionListManager.updateImages(on: regionDetails)
        render(.presenting(regionListManager.threadSafeRegionList))
    }
}
