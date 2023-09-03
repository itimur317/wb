import Foundation

enum URLPath {
    case list
    
    var rawValue: String {
        switch self {
        case .list:
            return "/api/guide-service/v1/getBrands"
        }
    }
}
