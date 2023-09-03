import Foundation

// MARK: - Update image
extension RegionDetails {
    func withUpdated(
        _ image: Image,
        at index: Int
    ) -> RegionDetails {
        var images = self.images
        images[index] = image
        
        return RegionDetails(
            title: self.title,
            id: self.id,
            viewsCount: self.viewsCount,
            images: images,
            isLiked: self.isLiked
        )
    }
    
    func withUpdated(_ images: [Image]) -> RegionDetails {
        RegionDetails(
            title: self.title,
            id: self.id,
            viewsCount: self.viewsCount,
            images: images,
            isLiked: self.isLiked
        )
    }
}

// MARK: - Mark like/unlike
extension RegionDetails {
    func markedAsLiked() -> RegionDetails {
        RegionDetails(
            title: self.title,
            id: self.id,
            viewsCount: self.viewsCount,
            images: self.images,
            isLiked: true
        )
    }
    
    func markedAsUnliked() -> RegionDetails {
        RegionDetails(
            title: self.title,
            id: self.id,
            viewsCount: self.viewsCount,
            images: self.images,
            isLiked: false
        )
    }
}

// MARK: - Equatable
extension RegionDetails: Equatable {
    static func == (
        lhs: RegionDetails,
        rhs: RegionDetails
    ) -> Bool {
        lhs.title == rhs.title &&
        lhs.id == rhs.id &&
        lhs.viewsCount == rhs.viewsCount &&
        lhs.images == rhs.images &&
        lhs.isLiked == rhs.isLiked
    }
}
