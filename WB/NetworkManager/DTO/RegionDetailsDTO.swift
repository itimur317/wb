import Foundation

struct RegionDetailsDTO: Codable {
    let title: String
    let id: String
    let viewsCount: Int
    let imagesURL: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case viewsCount
        case id = "brandId"
        case imagesURL = "thumbUrls"
    }
}

extension RegionDetails {
    init?(from dto: RegionDetailsDTO) {
        let urls = dto.imagesURL.compactMap { URL(string: $0) }
        guard urls.count == dto.imagesURL.count else {
            return nil
        }
        
        self.title = dto.title
        self.id = dto.id
        self.viewsCount = dto.viewsCount
        self.images = urls.map { Image(url: $0) }
        self.isLiked = false
    }
}
