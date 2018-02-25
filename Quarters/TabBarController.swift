//
//  TabBarController.swift
//  Bettermint
//
//  Created by Michael Bi on 1/19/18.
//  Copyright © 2018 MB&JG. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var transactionVC : TransactionsViewController = TransactionsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tab Bar specific code
    override func viewDidAppear(_ animated: Bool) {
        self.setupMiddleButton()
    }
    
    // TabBar - Setup middle button
    func setupMiddleButton(){
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = self.view.bounds.width / 2 - menuButtonFrame.size.width / 2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.clear
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        self.view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "addButton.jpeg"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: UIControlEvents.touchUpInside)
        
        
        self.view.layoutIfNeeded()
    }

    // Menu button action touch
    @objc func menuButtonAction(sender: UIButton){
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionView") as! AddTransactionViewController
        self.addChildViewController(popUpVC)
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)
        popUpVC.didMove(toParentViewController: self)
        self.selectedIndex = 0
    }

}
