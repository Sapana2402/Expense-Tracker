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
        guard let (user, userTransactions) = getUserAndTransactions() else { return }

        self.transactions = SignInVM.shared.fetch(Transaction.self)
        listTableView.reloadData()
        listTableView.layoutIfNeeded()
        heightOfContent.constant = listTableView.contentSize.height + 10

        let (totalIncome, totalExpense, calculatedBalance) = calculateTotals(from: userTransactions)

        // Update UI
        availableBalance.text = "$ \(String(format: "%.2f", calculatedBalance))"
        earned.text = "$ \(String(format: "%.2f", totalIncome))"
        spent.text = "$ \(String(format: "%.2f", totalExpense))"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToAddExpense" {
            if let destinatinVC = segue.destination as? ExpenseVC {
                destinatinVC.selectedTitle = selectedMenuTitle!
            }
        }
    }

    func handleMenu() {
        let actionCloser = { (action: UIAction) in
            self.selectedMenuTitle = action.title
            self.performSegue(withIdentifier: "navigateToAddExpense", sender: self)
        }

        var menuChildren: [UIMenuElement] = []
        for list in dataSource {
            menuChildren.append(UIAction(title: list, handler: actionCloser))
        }

        addBtn.menu = UIMenu(options: .displayInline, children: menuChildren)
        addBtn.showsMenuAsPrimaryAction = true
        addBtn.changesSelectionAsPrimaryAction = true
    }

    func formatDate(from stringDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: stringDate) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return stringDate
    }

    @IBAction func handlePdf(_ sender: UIButton) {
        guard let (_, userTransactions) = getUserAndTransactions() else { return }

        let (totalIncome, totalExpense, calculatedBalance) = calculateTotals(from: userTransactions)

        let format = UIGraphicsPDFRendererFormat()
        let pageWidth = 595.2
        let pageHeight = 841.8
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = renderer.pdfData { ctx in
            ctx.beginPage()

            let title = "Expense Tracker Report"
            let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20)]
            title.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttr)

            let summary = """
            Total Income: ₹\(String(format: "%.2f", totalIncome))
            Total Expense: ₹\(String(format: "%.2f", totalExpense))
            Available Balance: ₹\(String(format: "%.2f", calculatedBalance))
            """
            let summaryAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
            summary.draw(at: CGPoint(x: 20, y: 60), withAttributes: summaryAttr)

            var yOffset: CGFloat = 140
            let lineSpacing: CGFloat = 22

            for t in userTransactions {
                let dateString = formatDate(from: t.date ?? "")
                let line = "• \(t.type ?? "") - ₹\(t.amount) | \(t.category ?? "") | \(t.descriptions ?? "") | \(dateString)"
                let lineAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
                line.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: lineAttr)

                yOffset += lineSpacing
                if yOffset > pageHeight - 40 {
                    ctx.beginPage()
                    yOffset = 40
                }
            }
        }

        let fileName = "Expense_Report_\(UUID().uuidString.prefix(5)).pdf"
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docURL.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            print("✅ PDF saved at: \(fileURL.path)")
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            present(activityVC, animated: true)
        } catch {
            print("❌ Failed to write PDF: \(error)")
        }
    }

    // MARK: - Helper Methods

    func getUserAndTransactions() -> (User, [Transaction])? {
        let users = SignInVM.shared.fetch(User.self)
        guard let user = users.first else {
            print("❌ No user found")
            return nil
        }
        let transactions = user.transactions?.allObjects as? [Transaction] ?? []
        return (user, transactions)
    }

    func calculateTotals(from transactions: [Transaction]) -> (income: Double, expense: Double, balance: Double) {
        var totalIncome = 0.0
        var totalExpense = 0.0

        for transaction in transactions {
            if transaction.type == "Income" {
                totalIncome += transaction.amount
            } else if transaction.type == "Expense" {
                totalExpense += transaction.amount
            }
        }

        return (totalIncome, totalExpense, totalIncome - totalExpense)
    }
}

// MARK: - UITableView Delegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {

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

        if listData.type == "Expense" {
            cell.cellIcon.image = UIImage(systemName: "chevron.down.2")
            cell.cellIcon.tintColor = .red
        } else {
            cell.cellIcon.image = UIImage(systemName: "chevron.up.2")
            cell.cellIcon.tintColor = .green
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        return spacerView
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transactionToDelete = transactions[indexPath.section]
            AppManager.shared.context.delete(transactionToDelete)
            SignInVM.shared.saveToCoreData()

            transactions.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .automatic)
            tableView.layoutIfNeeded()
            heightOfContent.constant = tableView.contentSize.height + 10
            loadTransactions()
        }
    }
}
