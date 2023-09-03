import Foundation

typealias ImageResult = Result<Image, NetworkError>

protocol ImageProviding: AnyObject {
    func loadImage(
        by url: URL,
        completion: @escaping (ImageResult) -> Void
    )
}
