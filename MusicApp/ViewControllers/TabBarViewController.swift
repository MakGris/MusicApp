//
//  TabBarViewController.swift
//  MusicApp
//
//  Created by Maksim Grischenko on 20.06.2022.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private var middleButton = UIButton.middleButton
//    новые кнопки
    private var buttonTapped = false
    private var index = Int()
    private var optionButtons: [UIButton] = []
    var options = [
       option(name: "A", image: UIImage(systemName: "a") ?? UIImage(), segue: "a"),
       option(name: "B", image: UIImage(systemName: "a") ?? UIImage(), segue: "b"),
       option(name: "B", image: UIImage(systemName: "a") ?? UIImage(), segue: "b")
    ]
    struct option {
       var name = String()
       var image = UIImage()
       var segue = String()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNewTabBar()
        addMiddleButton()
        hideOldTabBar()
        hidestandartButton()
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIView.animate(withDuration: 0.15, animations: ({
            self.middleButton.transform = CGAffineTransform(rotationAngle: 0)
            self.middleButton.backgroundColor = .gray
            self.middleButton.layer.borderWidth = 0
            
        }))
    }
    
    @objc func middleButtonPressed(sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: ({
            self.middleButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4 )
            
            self.middleButton.layer.borderWidth = 3
            self.middleButton.layer.borderColor = UIColor.white.cgColor
            self.middleButton.backgroundColor = .tabBarItemAccent
            self.selectedIndex = 1
            if let navVC = self.tabBarController?.viewControllers?[1] as? UINavigationController {
                navVC.pushViewController(FavoritesTableViewController(), animated: true)
            }
        }))
        buttonTapped = true
        setUpButtons(count: 2, center: middleButton, radius: 80)
    }
    
    @objc func backgroundPressed(sender: UIButton) {
            if buttonTapped == true {
                middleButton.sendActions(for: .touchUpInside)
            } else {
                sender.isUserInteractionEnabled = false
                sender.removeFromSuperview() }}
}

extension TabBarViewController {
    
    private func setNewTabBar() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
    
    private func hideOldTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = .none
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func hidestandartButton() {
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                items[1].isEnabled = false
            }
        }
    }
    
    private func addMiddleButton() {
        tabBar.addSubview(middleButton)
        let size = CGFloat(50)
        let layerHeight = CGFloat(5)
        let constant: CGFloat = 20 + ( layerHeight / 2 ) - 5
        middleButton.layer.cornerRadius = size / 2

        let constraints = [
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: constant),
            middleButton.heightAnchor.constraint(equalToConstant: size),
            middleButton.widthAnchor.constraint(equalToConstant: size)
        ]
        for constraint in constraints {
            constraint.isActive = true
        }

        middleButton.layer.masksToBounds = false
        middleButton.translatesAutoresizingMaskIntoConstraints = false

        middleButton.addTarget(self, action: #selector(middleButtonPressed), for: .touchUpInside)
    }
    
    private func createButton(size: CGFloat) -> UIButton {
            
            // button's appearance
            let buttonBGColor = UIColor.tabBarItemAccent
            let button = UIButton(type: .custom)
            button.backgroundColor = buttonBGColor
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // button's constraints
            button.widthAnchor.constraint(equalToConstant: size).isActive = true
            button.heightAnchor.constraint(equalToConstant: size).isActive = true
            button.layer.cornerRadius = size / 2
            
            // double check that the button is tapped
            if buttonTapped == true {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations:  {
                    button.imageView?.tintColor = .clear
                    button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: { _ in
                    button.imageView?.tintColor = .white
                    button.transform = CGAffineTransform(scaleX: 1, y: 1) })}
            
            // return button
            return button
            
        }
    
    private func createBackground() -> UIButton {
            
            // background button to deselect middle button
            let button = UIButton(type: .custom)
            button.backgroundColor = .clear
            button.titleLabel?.text = ""
            view.addSubview(button)
            
            // button's constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            
            // return button
            return button
            
        }
    
    func setUpButtons(count: Int, center: UIView, radius: CGFloat) {
            
            // set buttons distance using degrees
            let degrees = 135 / CGFloat(count)
            
            // create background to avoid other interactions
            let background = createBackground()
            background.addTarget(self, action: #selector(backgroundPressed(sender:)), for: .touchUpInside)
            background.addTarget(self, action: #selector(backgroundPressed(sender:)), for: .touchDragInside)
            optionButtons.append(background)
            
            // set middle button to be in front
//            tabBar.bringSubviewToFront(middleButton)
            
            // create three buttons
            for i in 0 ..< count {
                
                // set index to assign action
                index = i
                
                // create and set the buttons
                let button = createButton(size: 44)
                optionButtons.append(button)
                view.addSubview(button)
                button.imageView?.isHidden = false
                
                // set constraints using trigonometry
                let x = cos(degrees * CGFloat(i+1) * .pi/180) * radius
                let y = sin(degrees * CGFloat(i+1) * .pi/180) * radius
                button.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor, constant: -x).isActive = true
                button.centerYAnchor.constraint(equalTo: center.centerYAnchor, constant: -y).isActive = true
                
                // final setup
                button.setImage(options[i].image, for: .normal)
                view.bringSubviewToFront(button)
                button.addTarget(self, action: #selector(optionHandler(sender:)), for: .touchUpInside)
            }
        }


        @objc func optionHandler(sender: UIButton) {
            
            switch index {
                
            case 0: print("Button 1 was pressed.")
            case 1: print("Button 2 was pressed.")
            default: print("Button 3 was pressed.")
                
            }
        }
    
    private func removeButtons() {
            
            for button in optionButtons {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                    button.transform = CGAffineTransform(scaleX: 1.15, y: 1.1)
                }, completion: { _ in
                    button.alpha = 0
                    if button.alpha == 0 {
                        button.removeFromSuperview()
                    }
                })
            }
        }
   
}




