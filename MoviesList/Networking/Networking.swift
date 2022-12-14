import Foundation

protocol DataProvider {
    func fetchData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> SessionDataTask
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

    func fetchData(
        with url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> SessionDataTask {

        session.dataTask(with: url) { data, _, error in

            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkingError.unknownError))
            }
        }
    }
    
    func createFetchTask(with url: URL) -> Task<Data, Error> {
        let task = Task { () async throws -> Data in
            try Task.checkCancellation()
            let result = try await session.data(from: url)
            return result.0
        }
        return task
    }
}
