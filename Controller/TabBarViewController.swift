//
//  TabBarViewController.swift
//  TheMovieDB
//
//  Created by mac on 4/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titles = ["Фильмы", "Жанры"]
        let tabBarImages = [UIImage(named: "movie"), UIImage(named: "genre")]
        for (index, item) in (self.tabBar.items?.enumerated())!  {
            item.title = titles[index]
            item.image = tabBarImages[index]
        }
        
        UITabBar.appearance().tintColor = UIColor.purple
       
        
        
    }

}
