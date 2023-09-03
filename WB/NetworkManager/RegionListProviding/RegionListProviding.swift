import Foundation

protocol RegionListProviding: AnyObject {
    func fetchRegionList(
        completion: @escaping (RegionListResult) -> Void
    )
}
