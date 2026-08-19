import Foundation

private let apiKey = "856885b6a7d193685b50411ad8897ac2"

extension URL {
    static func popularMoviesURL(at page: Int, apiKey: String = apiKey) -> URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)") else {
            fatalError("Failure to create popular movies URL")
        }

        return url
    }
}
