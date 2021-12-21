import UIKit

class TabBar: UITabBarController {

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    // MARK: Functions
    func setupVCs() {
            viewControllers = [
                createNavController(for: FolderNotesController(), title: NSLocalizedString("Diary", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
                createNavController(for: NoteDetailController(), title: NSLocalizedString("Expenses", comment: ""), image: UIImage(systemName: "house")!),
                //createNavController(for: ViewController(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person")!)
            ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
           let navController = UINavigationController(rootViewController: rootViewController)
           navController.tabBarItem.title = title
           navController.tabBarItem.image = image
           navController.navigationBar.prefersLargeTitles = true
           rootViewController.navigationItem.title = title
           return navController
    }
    

}
