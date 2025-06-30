//
//  ExpenseVC.swift
//  ExpenseTracker
//
//  Created by MACM26 on 26/06/25.
//

import UIKit

class ExpenseVC: UIViewController {

    var selectedTitle: String?
    @IBOutlet var mainStack: UIView!
    
    @IBOutlet weak var desc: UITextField!
    
    @IBAction func handleCategory(_ sender: UITextField) {
        print("abcdddd")
    }
    @IBOutlet weak var methodName: UIButton!
    @IBOutlet weak var amount: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        handleBtnText()
        handleTextFieldUI()
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          applyGradient()
      }

    func handleBtnText()  {
        methodName.setTitle("Add \(selectedTitle!)", for: .normal)
        if selectedTitle == "Expense" {
            methodName.setImage(UIImage(systemName: "chevron.down.2"), for: .normal)
        }else{
            methodName.setImage(UIImage(systemName: "chevron.up.2"), for: .normal)
        }
    }
    
    func handleTextFieldUI() {
        amount.backgroundColor = .clear
        amount.borderStyle = .none
        amount.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 32)
            ]
        )
    }
    
    @IBAction func handleBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    
    
    @IBAction func handleSaveBtn(_ sender: UIButton) {
    }
    
}
