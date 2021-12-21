import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        let navController = UINavigationController(rootViewController: FolderNotesController())
        
        //window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        //window?.windowScene = windowScene
        //window?.rootViewController = navController
        //window?.makeKeyAndVisible()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let home = TabBar()
        self.window?.rootViewController = home
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

