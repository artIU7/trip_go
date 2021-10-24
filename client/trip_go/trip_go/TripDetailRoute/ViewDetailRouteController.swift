//
//  ViewDetailRouteController.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//

import UIKit
import SnapKit

class ViewDetailRouteController: UIViewController {
        
    
      let closeView = UIButton(type: .system)

      let fullView: CGFloat = 100
      var partialView: CGFloat {
            return UIScreen.main.bounds.height - 200 
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        
        view.addGestureRecognizer(gesture)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.2130090282, green: 0.2321631757, blue: 0.2820363943, alpha: 1)
        
        self.layoutUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                let frame = self?.view.frame
                let yComponent = self?.partialView
                self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
            })
        }
        
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
      
        
        @IBAction func close(_ sender: AnyObject) {
           
        }
        
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
            
            let translation = recognizer.translation(in: self.view)
            let velocity = recognizer.velocity(in: self.view)
            let y = self.view.frame.minY
            if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
                self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
            
            if recognizer.state == .ended {
                var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
                
                duration = duration > 1.3 ? 1 : duration
                
                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                    if  velocity.y >= 0 {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    }
                    
                    }, completion: nil)
            }
        }
    
    func layoutUI()
    {
        let colorButton = #colorLiteral(red: 0.3898727347, green: 0.3937328608, blue: 0.3937328608, alpha: 1)
        // layer
        closeView.setImage(UIImage(named: "closeDetail"), for: .normal)
        closeView.tintColor = .white
        closeView.backgroundColor = colorButton
        closeView.layer.cornerRadius = 5
        view.addSubview(closeView)
        closeView.addTarget(self, action: #selector(self.closeAction(_:)), for: .touchUpInside)
        closeView.snp.makeConstraints { (marker) in
            marker.height.equalTo(30)
            marker.width.equalTo(30)
            marker.top.equalToSuperview().inset(5)
            marker.rightMargin.equalToSuperview().inset(5)
        }
    }
    @objc func closeAction(_ sender:UIButton)
    {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
        //self.dismiss(animated: true, completion: nil)
        //self.view.isHidden = true
        setViewHide(hidden: true)
    }
    
    func setViewHide (hidden:Bool) {
        
        
        let height = view.frame.height
        let width  = view.frame.width
        
        if hidden {
            //UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)

            //})
        }else {

            //UIView.animate(withDuration: 0.3, animations: {
                self.view.frame =  CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
            //})
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
