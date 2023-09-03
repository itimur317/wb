import Foundation

struct RegionListDTO: Codable {
    let regionsDetailsDTO: [RegionDetailsDTO]
    
    enum CodingKeys: String, CodingKey {
        case regionsDetailsDTO = "brands"
    }
}

extension RegionListDTO {
    var convertedToRegionList: RegionList? {
        let list = regionsDetailsDTO.compactMap { dto in
            RegionDetails(from: dto)
        }
        
        guard list.count == regionsDetailsDTO.count else { return nil }
        return list
    }
}
