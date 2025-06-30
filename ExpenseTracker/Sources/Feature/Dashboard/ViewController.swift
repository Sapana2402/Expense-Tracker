//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by MACM26 on 26/06/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    let dataSource = ["Expense", "Income"]
    var selectedMenuTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        handleMenu()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToAddExpense"{
           if let destinatinVC = segue.destination as? ExpenseVC{
                destinatinVC.selectedTitle = selectedMenuTitle
            }
        }
    }
    func handleMenu() {
        let actionCloser = {(action: UIAction) in
            self.selectedMenuTitle = action.title
            self.performSegue(withIdentifier: "navigateToAddExpense", sender: self)
        }
        var menuChildren: [UIMenuElement] = []
        for list in dataSource {
            menuChildren.append(UIAction(title: list,handler: actionCloser))
        }
        
        addBtn.menu = UIMenu(options: .displayInline,children: menuChildren)
        addBtn.showsMenuAsPrimaryAction = true
        addBtn.changesSelectionAsPrimaryAction = true
    }
}

