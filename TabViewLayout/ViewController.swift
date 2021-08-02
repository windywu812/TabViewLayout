//
//  ViewController.swift
//  TabViewLayout
//
//  Created by Windy on 22/06/21.
//

import UIKit

class ViewController: TabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TabView"
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .systemBlue
        vc1.title = "Test1"
    
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .black.withAlphaComponent(0.3)
        vc2.title = "Test2"
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .systemRed.withAlphaComponent(0.3)
        vc3.title = "Test3"
        
        addViewControllers(viewControllers: [vc1, vc2, vc3])
    }
    
}
