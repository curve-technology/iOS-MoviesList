import Combine
import SwiftUI

struct PopularMoviesListView: View {
    @State var movies: [Movie] = []
    @State var sessionDataTask: SessionDataTask?
    @State var dataTask: Task<Data, Error>?
    let dataProvider: DataProvider

    init(dataProvider: DataProvider = NetworkClient()) {
        self.dataProvider = dataProvider
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(movies, id: \.identifier) { movie in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(movie.originalTitle)
                            .font(.title3)
                        Text(DateFormatter.releaseDateDisplay.string(from: movie.releaseDate))
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Text(movie.overview)
                            .padding(.vertical, .mediumSpacing)
                            .lineLimit(6)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Popular Movies")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchMovies2()
            }
            .onDisappear {
                sessionDataTask?.cancel()
            }
        }
    }
    
    func fetchMovies() {
        sessionDataTask = dataProvider.fetchData(with: .popularMoviesURL(at: 1)) { result in
            switch result {
            case let .success(data):
                let popularMovies = try? JSONDecoder.popularMoviesDecoder.decode(PopularMovies.self, from: data)
                DispatchQueue.main.async {
                    self.movies = popularMovies?.results ?? []
                }
            case .failure:
                return
            }
        }
        sessionDataTask?.resume()
    }
    
    func fetchMovies2() {
        Task {
            dataTask = dataProvider.createFetchDataTask(with: URL.popularMoviesURL(at: 1))
            switch await dataTask?.result {
            case let .success(data):
                let popularMovies = try? JSONDecoder.popularMoviesDecoder.decode(PopularMovies.self, from: data)
                DispatchQueue.main.async {
                    self.movies = popularMovies?.results ?? []
                }
            case .failure, .none:
                return
            }
        }
    }
}

struct PopularMoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesListView()
    }
}
