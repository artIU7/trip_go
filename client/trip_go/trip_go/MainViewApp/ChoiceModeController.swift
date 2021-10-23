//
//  ChoiceModeController.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//

import Foundation
import UIKit
import SnapKit

class ChoiceModeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configLayout()
        // Do any additional setup after loading the view.
    }
    
    func configLayout() {
        view.backgroundColor = #colorLiteral(red: 0.7590399673, green: 0.7374965167, blue: 0.5871765646, alpha: 1)
        // заголовок экрана приветсвия
        let titleScreen = UILabel()
        titleScreen.font = UIFont.systemFont(ofSize: 30)
        titleScreen.numberOfLines = 0
        titleScreen.text = "Welcome to trip Go 🚇 ✈️ 🚗 "
        //
        view.addSubview(titleScreen)
        titleScreen.snp.makeConstraints { (marker) in
            marker.left.right.equalToSuperview().inset(30)
            marker.top.equalToSuperview().inset(80)
        }
        // button continie
        let tripCreatePush = UIButton(type: .system)
        tripCreatePush.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        tripCreatePush.setTitle("Trip Create", for: .normal)
        tripCreatePush.setTitleColor(.white, for: .normal)
        tripCreatePush.layer.cornerRadius = 15

        view.addSubview(tripCreatePush)
        tripCreatePush.snp.makeConstraints { (marker) in
            marker.bottom.equalToSuperview().inset(20)
            marker.leftMargin.equalToSuperview().inset(20)
            marker.width.equalTo(200)
            marker.height.equalTo(40)
        }
        
        tripCreatePush.addTarget(self, action: #selector(showApp), for: .touchUpInside)
        
        // button continie
        let tripGoPush = UIButton(type: .system)
        tripGoPush.backgroundColor = #colorLiteral(red: 0.3759136491, green: 0.6231091984, blue: 0.6783652551, alpha: 1)
        tripGoPush.setTitle("Trip Go", for: .normal)
        tripGoPush.setTitleColor(.white, for: .normal)
        tripGoPush.layer.cornerRadius = 15

        view.addSubview(tripGoPush)
        tripGoPush.snp.makeConstraints { (marker) in
            marker.bottom.equalToSuperview().inset(20)
            marker.rightMargin.equalToSuperview().inset(20)
            marker.width.equalTo(200)
            marker.height.equalTo(40)
        }
        
        tripGoPush.addTarget(self, action: #selector(showApp), for: .touchUpInside)
        // page controll
        let pageControl = UIPageControl()
            pageControl.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
            pageControl.numberOfPages = 2;
            pageControl.currentPage = 0;
            view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (marker) in
            marker.bottom.equalTo(tripGoPush).inset(40)
            marker.left.right.equalToSuperview().inset(30)
        }
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
extension ChoiceModeController {
    @objc func showApp() {
        
        let viewTours = MainWindowTabsTrip()
            //startTest.modalTransitionStyle = .flipHorizontal
        viewTours.modalPresentationStyle = .fullScreen
        viewTours.modalTransitionStyle = .crossDissolve
        show(viewTours, sender: self) 
        //present(startTest, animated: true, completion: nil)
        print("Launch second controller")
    }
}
