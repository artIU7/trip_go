//
//  TripFavoiriteController.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//

import UIKit

class TripFavoiriteController: UIViewController {

    // custom tint tab bar
    var tabBarTag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trip Favoirite"
        
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

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
           if tabBarTag == true {
               self.tabBarController?.tabBar.tintColor = UIColor.yellow
                self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.1156016763, green: 0.1961770704, blue: 0.3223885175, alpha: 1)//UIColor.cyan

           } else {
               self.tabBarController?.tabBar.tintColor = UIColor.white
           }
    }
}
