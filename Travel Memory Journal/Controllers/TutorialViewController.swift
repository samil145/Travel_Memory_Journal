//
//  ViewController.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 23.01.24.
//

import UIKit

class TutorialViewController: UIViewController {

    let backgroundImage = UIImageView()
    var frontView = UIView()
    let circle = UIView()
    let mapSymbol = UIImageView()
    let mainLabel = UILabel()
    let secondLabel = UILabel()
    var getStarted = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIApplication.shared.windows.first?.layer.speed = 0.1
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.clear
            ]
            appearance.backgroundColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
        
        // Do any additional setup after loading the view.
        
        // Background Image
        backgroundImage.frame = view.bounds
        backgroundImage.image = UIImage(named: "plane")
        
        // Blank View
        frontView = UIView(frame: CGRect(x: 0, y: (view.bounds.height/2) - 50, width: view.bounds.width, height: (view.bounds.height/2) + 50))
        frontView.backgroundColor = UIColor(rgb: 0xFEC8A2)
        frontView.layer.cornerRadius = 50
        
        // Circle
        circle.backgroundColor = UIColor(rgb: 0xD7E9FF)
        
        mapSymbol.image = UIImage(systemName: "map")
        mapSymbol.tintColor = .black
        
        mainLabel.text = "Travel Memory Journal"
        mainLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 35)
        mainLabel.textColor = UIColor(rgb: 0x2D0C57)
        
        secondLabel.text = "Main purpose of this app is reminding you best travel of your life with your pictures, memories you gathered there."
        secondLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        secondLabel.textColor = UIColor(rgb: 0x6F6F6F)
        secondLabel.textAlignment = .center
        secondLabel.lineBreakMode = .byWordWrapping
        secondLabel.numberOfLines = 0
        
        getStarted = UIButton(type: .system)
        getStarted.setTitle("Get Started", for: .normal)
        getStarted.setTitleColor(.white, for: .normal)
        getStarted.backgroundColor = .black
        getStarted.titleLabel?.font = UIFont(name: "Helvetica", size: 25)
        getStarted.addTarget(self, action: #selector(getStartButtonTapped), for: .touchUpInside)
        
        view.addSubview(backgroundImage)
        view.addSubview(frontView)
        view.addSubview(circle)
        view.addSubview(mapSymbol)
        view.addSubview(mainLabel)
        view.addSubview(secondLabel)
        view.addSubview(getStarted)
        
        circle.translatesAutoresizingMaskIntoConstraints = false
        mapSymbol.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        getStarted.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalToConstant: 100),
            circle.heightAnchor.constraint(equalToConstant: 100),
            circle.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 25),
            circle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mapSymbol.widthAnchor.constraint(equalToConstant: 50),
            mapSymbol.heightAnchor.constraint(equalToConstant: 50),
            mapSymbol.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            mapSymbol.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            
            mainLabel.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 34),
            mainLabel.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            
            secondLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 34),
            secondLabel.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            secondLabel.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2),
            
            getStarted.widthAnchor.constraint(equalToConstant: 210),
            getStarted.heightAnchor.constraint(equalToConstant: 55),
            getStarted.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
            getStarted.centerXAnchor.constraint(equalTo: circle.centerXAnchor)
        ])
        
        circle.layer.cornerRadius = 50
        circle.clipsToBounds = true
        getStarted.layer.cornerRadius = 25
    }
    
    @objc func getStartButtonTapped()
    {
        UserDefaults.standard.set(true, forKey: "notFirstInApp")
        
        let transition:CATransition = CATransition()
        transition.duration = 0.8
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            appearance.backgroundColor = UIColor.backgroundMain
            appearance.shadowColor = nil
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = UIColor.backgroundMain
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

