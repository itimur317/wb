import Foundation

final class DefaultNetworkManager: NetworkManager {
    private let imageProvider: ImageProviding
    private let regionListProvider: RegionListProviding
    
    init(
        imageProvider: ImageProviding,
        regionListProvider: RegionListProviding
    ) {
        self.imageProvider = imageProvider
        self.regionListProvider = regionListProvider
    }
    
    func fetchRegionList(
        completion: @escaping (RegionListResult) -> Void
    ) {
        regionListProvider.fetchRegionList { regionListResult in
            switch regionListResult {
            case let .success(regionList):
                var regionList = regionList
                completion(.success(regionList))
                
                // MARK: - ImageProviding
                for (index, region) in regionList.enumerated() {
                    guard let firstImage = region.images.first else {
                        return
                    }
                    
                    self.imageProvider.loadImage(
                        by: firstImage.url
                    ) { imageResult in
                        guard case let .success(image) = imageResult else { return }
                        regionList[index] = regionList[index].withUpdated(image, at: 0)
                        completion(.success(regionList))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
