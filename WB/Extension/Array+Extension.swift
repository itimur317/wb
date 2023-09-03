import Foundation

extension Array where Element == RegionDetails {
    func withUpdatedLikes(
        using likedRegionsIds: Set<String>
    ) -> RegionList {
        var resultArray = self
        for (index, region) in self.enumerated() {
            resultArray[index] = likedRegionsIds.contains(region.id)
                ? self[index].markedAsLiked()
                : self[index].markedAsUnliked()
        }
        return resultArray
    }
    
    func withUpdated(
        _ regionDetails: RegionDetails
    ) -> RegionList {
        var resultArray = self
        guard let index = self.firstIndex(
            where: { oldRegionDetails in
                regionDetails.id == oldRegionDetails.id
            }
        ) else { return self }
        
        resultArray[index] = regionDetails
        return resultArray
    }
    
    func withUpdated(
        _ images: [Image],
        on regionDetails: RegionDetails
    ) -> RegionList {
        var resultArray = self
        guard let index = self.firstIndex(
            where: { oldRegionDetails in
                regionDetails.id == oldRegionDetails.id
            }
        ) else { return self }
        
        resultArray[index] = regionDetails.withUpdated(images)
        return resultArray
    }
}
