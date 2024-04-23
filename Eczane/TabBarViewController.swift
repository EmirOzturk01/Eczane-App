//
//  TabBarViewController.swift
//  Eczane
//
//  Created by Emir Öztürk on 10.03.2024.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: PharmaciesViewController())
        let vc3 = UINavigationController(rootViewController: AddressesViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "map")
        vc2.tabBarItem.image = UIImage(systemName: "list.bullet")
        vc3.tabBarItem.image = UIImage(systemName: "location")
        
        vc1.title = "Harita"
        vc2.title = "Eczane Listesi"
        vc3.title = "Adreslerim"
        
        vc1.navigationBar.tintColor = .label
        vc2.navigationBar.tintColor = .label
        vc3.navigationBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3], animated: true)
        
        tabBar.tintColor = .red
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
        
        /*if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            //appearance.configureWithOpaqueBackground()
            //appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white
            tabBar.tintColor = .red
            tabBar.unselectedItemTintColor = .black
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }*/
    }
    
    override func viewDidLayoutSubviews() {
        tabBar.frame = CGRect(x: 40, y: self.view.frame.height-90, width: tabBar.frame.size.width-80, height: 50)
        tabBar.layer.cornerRadius = 20
        tabBar.clipsToBounds = true
    }
}

