import Foundation

struct HTTPResponse {
    static func handleNetworkResponse(for response: URLResponse?) -> Result<Void, NetworkError> {
        guard let response = response as? HTTPURLResponse else {
            return .failure(NetworkError.emptyResponseError)
        }

        switch response.statusCode {
        case 200...299: return .success(())
        case 401: return .failure(NetworkError.authenticationError)
        case 400...499: return .failure(NetworkError.badRequest)
        case 500...599: return .failure(NetworkError.serverError)
        default: return .failure(NetworkError.failed)
        }
    }
}
