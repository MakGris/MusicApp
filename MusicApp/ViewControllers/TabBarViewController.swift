//
//  TabBarViewController.swift
//  MusicApp
//
//  Created by Maksim Grischenko on 20.06.2022.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private var middleButton = UIButton.middleButton
    
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
    }
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
    
   
    
   
}




