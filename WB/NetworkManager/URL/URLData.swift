import Foundation

struct URLData {
    let urlProtocol: URLProtocol
    let urlHost: URLHost
    let urlPath: URLPath
    
    var url: URL {
        var urlComponents = URLComponents()
    
        urlComponents.scheme = urlProtocol.rawValue
        urlComponents.host = urlHost.rawValue
        urlComponents.path = urlPath.rawValue
        
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        return url
    }
}
