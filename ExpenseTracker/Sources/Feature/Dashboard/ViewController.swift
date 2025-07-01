//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by MACM26 on 26/06/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    let dataSource = ["Expense", "Income"]
    var selectedMenuTitle: String?
    var transactions: [Transaction] = []
    
    @IBOutlet weak var availableBalance: UILabel!
    @IBOutlet weak var earned: UILabel!
    @IBOutlet weak var spent: UILabel!
    
    @IBOutlet weak var heightOfContent: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.isScrollEnabled = false
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        handleMenu()
        loadTransactions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTransactions()
    }

    func loadTransactions() {
        let fetchedTransactions: [Transaction] = SignInVM.shared.fetch(Transaction.self)

        self.transactions = fetchedTransactions

        listTableView.reloadData()
        listTableView.layoutIfNeeded()

        heightOfContent.constant = listTableView.contentSize.height + 10
        let users = SignInVM.shared.fetch(User.self)
             guard let user = users.first else {
                 print("❌ No user found")
                 return
             }

             // Get user's transactions (one-to-many relationship)
             let userTransactions = user.transactions?.allObjects as? [Transaction] ?? []
        print("userTransactions",userTransactions)
             // Calculate totals
             var totalIncome: Double = 0
             var totalExpense: Double = 0

             for transaction in userTransactions {
                 if transaction.type == "Income" {
                     totalIncome += transaction.amount
                 } else if transaction.type == "Expense" {
                     totalExpense += transaction.amount
                 }
             }

             let totalBalance = user.totalBalance // Or: totalIncome - totalExpense

             // Update UI
             availableBalance.text = "$ \(String(format: "%.2f", totalBalance))"
             earned.text = "$ \(String(format: "%.2f", totalIncome))"
             spent.text = "$ \(String(format: "%.2f", totalExpense))"
        let calculatedBalance = totalIncome - totalExpense

        // Update UI
        availableBalance.text = "$ \(String(format: "%.2f", calculatedBalance))"

    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToAddExpense"{
           if let destinatinVC = segue.destination as? ExpenseVC{
               destinatinVC.selectedTitle = selectedMenuTitle!
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

extension ViewController : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        transactions.count
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as! ListTableViewCell
        let listData = transactions[indexPath.section]
        cell.amount.text = "\(listData.amount)"
        cell.category.text = listData.category
        cell.desc.text = listData.descriptions
        if listData.type == "Expense"{
            cell.cellIcon.image = UIImage(systemName: "chevron.down.2")
            cell.cellIcon.tintColor = .red
        }else{
            cell.cellIcon.image = UIImage(systemName: "chevron.up.2")
            cell.cellIcon.tintColor = .green
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 // This is your margin (space) between cells
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear // or match your background color
        return spacerView
    }

}

