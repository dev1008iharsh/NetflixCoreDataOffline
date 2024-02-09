//
//  ViewController.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 19/12/23.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .systemRed
        
        //view.backgroundColor = .white
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        
        let vc2 = UINavigationController(rootViewController: UpComingVC())
        
        let vc3 = UINavigationController(rootViewController: SearchVC())

        let vc4 = UINavigationController(rootViewController: DownlodsVC())

        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "Upcoming"
        vc3.tabBarItem.title = "Search"
        vc4.tabBarItem.title = "Downlods"
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        
    }

   
     
    
 
}

