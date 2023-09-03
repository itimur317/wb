import Foundation

typealias RegionListDTOResult = Result<RegionListDTO, NetworkError>

final class RegionListProvider: RegionListProviding {
    private var urlData: URLData
    private let request: HTTPRequest
    
    private let completionQueue: DispatchQueue
    private let backgroundQueue: DispatchQueue
    
    init(
        urlData: URLData = URLData(
            urlProtocol: .https,
            urlHost: .host,
            urlPath: .list
        ),
        request: HTTPRequest = DefaultHTTPRequest(),
        completionQueue: DispatchQueue = DispatchQueue.main,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background)
    ) {
        self.urlData = urlData
        self.request = request
        self.completionQueue = completionQueue
        self.backgroundQueue = backgroundQueue
    }
    
    func fetchRegionList(
        completion: @escaping (RegionListResult) -> Void
    ) {
        backgroundQueue.async { [weak self] in
            guard let self else { return }
            
            self.request.execute(
                url: self.urlData.url,
                requestType: .get
            ) { (result: RegionListDTOResult) in
                self.completionQueue.async {
                    switch result {
                    case let .success(dto):
                        guard let regionList = dto.convertedToRegionList else {
                            completion(.failure(.parsingError))
                            return
                        }
                        completion(.success(regionList))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
