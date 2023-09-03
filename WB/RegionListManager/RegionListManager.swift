import Foundation

protocol RegionListManager: AnyObject {
    var threadSafeRegionList: RegionList { get set }
    func didReact(on regionDetails: RegionDetails)
    func updateImages(on regionDetails: RegionDetails)
}
