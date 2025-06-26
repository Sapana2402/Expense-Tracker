//
//  ExpenseVC.swift
//  ExpenseTracker
//
//  Created by MACM26 on 26/06/25.
//

import UIKit

class ExpenseVC: UIViewController {

    @IBOutlet var mainStack: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    This method is called after the view controller lays out its subviews, so:
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          applyGradient()
      }

    
      private func applyGradient() {
          let gradientLayer = CAGradientLayer()
          gradientLayer.frame = mainStack.bounds
          gradientLayer.colors = [
            UIColor(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1).cgColor, // #262626
              UIColor(red: 140/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1).cgColor  // #8C0A0A
          ]
          gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
          gradientLayer.endPoint = CGPoint(x: 0, y: 1)     // Bottom-right
          mainStack.layer.insertSublayer(gradientLayer, at: 0)
      }

}
