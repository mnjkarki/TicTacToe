//
//  MenuViewController.swift
//  tictactoc
//
//  Created by manoj karki on 1/20/18.
//  Copyright © 2018 manoj karki. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "menuBackground")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ViewController {
        if let selectedBtn = sender as? UIButton {
            if selectedBtn.tag == 1 {
                 destination.gameType = GameType.singleplayer
            }else {
                  destination.gameType = GameType.multiplayer
            }
        }
        }
    }
 

}
