import Foundation

protocol DataProvider {
    func createFetchTask(with url: URL) -> Task<Data, Error>
}

protocol SessionDataTask {
    func resume()
    func cancel()
}

extension URLSessionDataTask: SessionDataTask {}

enum NetworkingError: Error {
    case unknownError
}

struct NetworkClient: DataProvider {

    private let session = URLSession.shared
    
    func createFetchTask(with url: URL) -> Task<Data, Error> {
        let task = Task { () async throws -> Data in
            try Task.checkCancellation()
            let result = try await session.data(from: url)
            return result.0
        }
        return task
    }
}
