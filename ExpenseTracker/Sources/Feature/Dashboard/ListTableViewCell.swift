//
//  ListTableViewCell.swift
//  ExpenseTracker
//
//  Created by MACM26 on 30/06/25.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var cellIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
