import Foundation

final class DefaultRegionListManager: RegionListManager {
    private var regionList: RegionList
    private var likedRegionsIds: Set<String> = []
    
    private let isolationQueue = DispatchQueue(
        label: "wb.regionListManager.isolation",
        attributes: .concurrent
    )
    
    var threadSafeRegionList: RegionList {
        get {
            isolationQueue.sync {
                regionList.withUpdatedLikes(using: likedRegionsIds)
            }
        }
        set {
            isolationQueue.async(flags: .barrier) {
                guard self.regionList != newValue else { return }
                self.regionList = newValue
            }
        }
    }
    
    init(_ regionList: RegionList) {
        self.regionList = regionList
    }
    
    func didReact(on regionDetails: RegionDetails) {
        isolationQueue.async(flags: .barrier) {
            if self.likedRegionsIds.contains(regionDetails.id) {
                self.likedRegionsIds.remove(regionDetails.id)
            }
            else {
                self.likedRegionsIds.insert(regionDetails.id)
            }
        }
    }
    
    func updateImages(on regionDetails: RegionDetails) {
        isolationQueue.async(flags: .barrier) {
            let images = regionDetails.images
            self.regionList = self.regionList.withUpdated(
                images,
                on: regionDetails
            )
        }
    }
}
