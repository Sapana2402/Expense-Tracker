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

    @IBOutlet weak var heightOfContent: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        heightOfContent.constant = listTableView.contentSize.height

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as! ListTableViewCell
        let listData = transactions[indexPath.row]
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
    
    
}

