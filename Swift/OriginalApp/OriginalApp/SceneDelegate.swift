//
//  SceneDelegate.swift
//  OriginalApp
//
//  Created by user203611 on R 3/09/02.
//

import UIKit
import NCMB

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let ud = UserDefaults.standard
        let isLogin = ud.bool(forKey: "isLogin")
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        
        if isLogin == true {
            
            let user = NCMBUser.current()
            if user?.object(forKey: "position") as? String == "高校生.高校生の保護者" {
                //ログイン中
                self.window = window
                let storyboard = UIStoryboard(name: "Main02", bundle: Bundle.main)
                //最初の画面
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabbarController")
                self.window?.rootViewController = rootViewController
                self.window?.backgroundColor = UIColor.white
                self.window?.makeKeyAndVisible()
                
            } else {
                //ログイン中
                self.window = window
                let storyboard = UIStoryboard(name: "Main01", bundle: Bundle.main)
                //最初の画面
                let rootViewController = storyboard.instantiateViewController(identifier: "RootTabbarController")
                self.window?.rootViewController = rootViewController
                self.window?.backgroundColor = UIColor.white
                self.window?.makeKeyAndVisible()
            }
           
        } else {
            //ログインしていない
            self.window = window
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(identifier: "rootNavigationController")
            self.window?.rootViewController = rootViewController
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

