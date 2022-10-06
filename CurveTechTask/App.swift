import SwiftUI

// INFO: To work with UIKit variant just add `SceneDelegate` file as a member to `CurveTechTask` target (in file inspector)

@main
struct CurveTechTask: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            PopularMoviesListView()
        }
    }
}
