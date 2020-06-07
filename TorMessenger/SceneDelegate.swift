import UIKit
import RealmSwift
import SwiftyUserDefaults

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let authVC = StoryboardScene.Auth.authViewController.instantiate()
        let authNC = UINavigationController(rootViewController: authVC)
        authNC.isNavigationBarHidden = true
        
        if Defaults[\.username] == nil || Defaults[\.passwordHash] == nil {
            window?.rootViewController = authVC
            window?.makeKeyAndVisible()
        } else {
            initializeViews()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(initializeViews),
                                               name: NSNotification.Name(rawValue: "loginSuccess"), object: authVC)
    }
    
    @objc func initializeViews() {
        let chatsVC = StoryboardScene.Chats.chatsViewController.instantiate()
        chatsVC.title = "Chats"
        let chatsNC = UINavigationController(rootViewController: chatsVC)
        if #available(iOS 11.0, *) {
            chatsNC.navigationBar.prefersLargeTitles = true
        }
        
        let torServiceVC = StoryboardScene.TorIndicator.torIndicatorViewController.instantiate()
        torServiceVC.title = "Tor Connection"
        let torServiceNC = UINavigationController(rootViewController: torServiceVC)
        if #available(iOS 11.0, *) {
            torServiceNC.navigationBar.prefersLargeTitles = true
        }
        
        //        let contactsVC = StoryboardScene.Contacts.contactsViewController.instantiate()
        //        contactsVC.title = "Contacts"
        //        let contactsNC = UINavigationController(rootViewController: contactsVC)
        //        if #available(iOS 11.0, *) {
        //            contactsNC.navigationBar.prefersLargeTitles = true
        //        }
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([chatsNC, torServiceNC], animated: false)
        
        //        let contactsTab = tabBarController.tabBar.items?[0]
        //        contactsTab?.image = UIImage(systemName: "person.fill")
        
        let chatsTab = tabBarController.tabBar.items?[0]
        chatsTab?.image = UIImage(systemName: "bubble.right.fill")
        
        let torIndicatorTab = tabBarController.tabBar.items?[1]
        torIndicatorTab?.image = UIImage(systemName: "link")
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
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

