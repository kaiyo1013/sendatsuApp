//
//  TabBarController.swift
//  OriginalApp
//
//  Created by 富永開陽 on 2021/09/26.
//

import UIKit
import RAMAnimatedTabBarController


class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // ナビゲージョンアイテムの文字色
//        UINavigationBar.appearance().tintColor = UIColor.white
//
//        // ナビゲーションバーのタイトルの文字色
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//
//        // ナビゲーションバーの背景色
//        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3093179762, green: 0.6738418341, blue: 0.3707079887, alpha: 1)
//
//        // ナビゲーションバーの背景の透過
//        (UINavigationBar.appearance() as UINavigationBar).setBackgroundImage(UIImage(), for: .default)
//
//        // ナビゲーションバーの下の影を無くす
//        UINavigationBar.appearance().shadowImage = UIImage()

       
    }
    

   

}

import RAMAnimatedTabBarController

class RAMBounceAnimation : RAMItemAnimation {

    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
    }

    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = textSelectedColor
    }

    func playBounceAnimation(_ icon : UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
}



