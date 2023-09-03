import Foundation

extension Image: Equatable {
    static func == (lhs: Image, rhs: Image) -> Bool {
        lhs.url == rhs.url &&
        lhs.uiImage == rhs.uiImage
    }
}
