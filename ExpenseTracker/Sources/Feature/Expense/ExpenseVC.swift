//
//  ExpenseVC.swift
//  ExpenseTracker
//
//  Created by MACM26 on 26/06/25.
//

import UIKit
import CoreData

class ExpenseVC: UIViewController {

    var selectedTitle: String = "Income"{
        didSet{
            updateCategoryDataSource()
        }
    }
    var selectedCategory: String = "Selected Category"
    @IBOutlet var mainStack: UIView!
    var dataSource : [String] = []

    
    func updateCategoryDataSource() {
        if selectedTitle == "Income" {
            dataSource = [
                "Selected Category",
                "Salary", "Freelance", "Business", "Interest", "Gift",
                "Investment Return", "Refund", "Bonus", "Rental Income", "Other"
            ]
        } else if selectedTitle == "Expense" {
            dataSource = [
                "Selected Category",
                "Food & Dining", "Transportation", "Shopping", "Groceries",
                "Rent", "Utilities", "Entertainment", "Health", "Travel",
                "Education", "Personal Care", "Subscription", "Loan Payment", "Others"
            ]
        }
//        handleMenu()
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectCategory: UIButton!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var methodName: UIButton!
    @IBOutlet weak var amount: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        handleBtnText()
        handleTextFieldUI()
        handleMenu()
    }
    
    func handleMenu()  {
        var menuElements:[UIMenuElement] = []
        
        let actionHandler = { (action: UIAction) in
            self.selectedCategory = action.title
            print("self.selectedCategory",self.selectedCategory)
        }
        
       for element in dataSource {
           menuElements.append(UIAction(title: element,handler: actionHandler))
        }
        selectCategory.menu = UIMenu(options: .displayInline,children: menuElements)
        selectCategory.showsMenuAsPrimaryAction = true
        selectCategory.changesSelectionAsPrimaryAction=true
    }
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          applyGradient()
      }

    func handleBtnText()  {
        methodName.setTitle("Add \(selectedTitle)", for: .normal)
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
          gradientLayer.startPoint = CGPoint(x: 0, y: 0)
          gradientLayer.endPoint = CGPoint(x: 0, y: 1)
          mainStack.layer.insertSublayer(gradientLayer, at: 0)
      }
    
    
    
    @IBAction func handleSaveBtn(_ sender: UIButton) {
        if let amountEntered = amount.text, !amountEntered.isEmpty,
           let descEntered = desc.text, !descEntered.isEmpty,
           selectedCategory != "Selected Category" {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            let transactionData = Transaction(context: AppManager.shared.context)
            transactionData.amount = Double(amountEntered) ?? 0
            transactionData.descriptions = descEntered
            transactionData.category = selectedCategory
            transactionData.type = selectedTitle
            transactionData.date = formatter.string(from: datePicker.date)
            
            let users = SignInVM.shared.fetch(User.self)
            if let user = users.first {
                transactionData.user = user
            }
            
            SignInVM.shared.saveToCoreData()
            self.dismiss(animated: true, completion: nil)

        } else {
            let alert = UIAlertController(title: "", message: "All fields required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }

   
    }
    
}
