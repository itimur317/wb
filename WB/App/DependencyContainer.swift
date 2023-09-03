import Foundation

final class DependencyContainer {
    private lazy var imageProvider: ImageProviding = ImageProvider()
    private lazy var regionListProvider: RegionListProviding = RegionListProvider()
    
    private lazy var regionListManager: RegionListManager = DefaultRegionListManager([])

    private lazy var errorDisplayer: ErrorDisplayable = ErrorDisplayer()
    private lazy var loadingDisplayer: LoadingDisplayable = LoadingDisplayer()
    
    private lazy var networkManager: NetworkManager = DefaultNetworkManager(
        imageProvider: imageProvider,
        regionListProvider: regionListProvider
    )
}

extension DependencyContainer {
    func makeRegionListViewController() -> RegionListViewController {
        RegionListViewController(
            regionListManager: regionListManager,
            imageProvider: imageProvider,
            networkManager: networkManager,
            errorDisplayer: errorDisplayer,
            loadingDisplayer: loadingDisplayer
        )
    }
}
