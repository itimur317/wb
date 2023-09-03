import Foundation

typealias RegionListResult = Result<RegionList, NetworkError>

protocol NetworkManager: AnyObject {
    init(
        imageProvider: ImageProviding,
        regionListProvider: RegionListProviding
    )
    
    func fetchRegionList(
        completion: @escaping (RegionListResult) -> Void
    )
}
