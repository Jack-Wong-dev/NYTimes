//
//  TabBarViewController.swift
//  JustUsLeagueNYTimes
//
//  Created by Jack Wong on 10/22/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let bestSellersVC = BestSellersVC()
    let favoritesVC = FavoritesVC()
    let settingsVC = SettingsVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bestSellersVC.tabBarItem = UITabBarItem(title: "NYT Best Sellers", image: UIImage(systemName: "rosette"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "bookmark"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
       
        self.viewControllers = [bestSellersVC, favoritesVC, settingsVC]

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
