import UIKit

final class ImageProvider: ImageProviding {
    private var cache: [URL: UIImage] = [:]
    
    private let request: HTTPRequest
    private let completionQueue: DispatchQueue
    private let backgroundQueue: DispatchQueue
    
    init(
        request: HTTPRequest = DefaultHTTPRequest(),
        completionQueue: DispatchQueue = DispatchQueue.main,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background)
    ) {
        self.request = request
        self.completionQueue = completionQueue
        self.backgroundQueue = backgroundQueue
    }
    
    func loadImage(
        by url: URL,
        completion: @escaping (ImageResult) -> Void
    ) {
        guard cache[url] == nil else {
            let image = Image(
                url: url,
                uiImage: cache[url]
            )
            completion(.success(image))
            return
        }
        
        backgroundQueue.async { [weak self] in
            guard let self else { return }
            
            self.request.execute(
                url: url,
                requestType: .get
            ) { result in
                self.completionQueue.async {
                    switch result {
                    case let .success(data):
                        guard let uiImage = UIImage(data: data) else {
                            completion(.failure(.parsingError))
                            return
                        }
                        
                        let image = Image(
                            url: url,
                            uiImage: uiImage
                        )
                        self.cache[url] = uiImage
                        completion(.success(image))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
