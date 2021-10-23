//
//  MainWindowTabsTrip.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//

import UIKit

class MainWindowTabsTrip: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = TripGoController()
        let tabOneBarItem = UITabBarItem(title: "Trip Go", image: UIImage(named: "transport_toogle"), selectedImage: UIImage(named: "transport_toogle"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = TripCreateController()
        let tabTwoBarItem2 = UITabBarItem(title: "Trip Create", image: UIImage(named: "route_tour"), selectedImage: UIImage(named: "route_tour"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Create Tab tree
        let tabTree = TripFavoiriteController()
        let tabTreeBarItem3 = UITabBarItem(title: "Trip Favoirite", image: UIImage(named: "route_tour"), selectedImage: UIImage(named: "route_tour"))
        
        tabTree.tabBarItem = tabTreeBarItem3
        
        // Create Tab four
        let tabFour = TripUserSettingController()
        let tabTreeBarItem4 = UITabBarItem(title: "Trip Setting", image: UIImage(named: "custom_property"), selectedImage: UIImage(named: "custom_property"))
        
        tabFour.tabBarItem = tabTreeBarItem4
        
        
        self.viewControllers = [tabOne, tabTwo, tabTree , tabFour ]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let appearance = UITabBarAppearance()
        //appearance.backgroundColor = #colorLiteral(red: 0.3791669923, green: 0.4272061604, blue: 0.434493125, alpha: 0.5) //.red
        
        tabBar.standardAppearance = appearance
        print("Selected \(viewController.title!)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 55
        tabBar.frame.origin.y = view.frame.height - 55
    }

}


