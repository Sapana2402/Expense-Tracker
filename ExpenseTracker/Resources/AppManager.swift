//
//  AppManager.swift
//  ExpenseTracker
//
//  Created by MACM26 on 27/06/25.
//

import UIKit
import CoreData

class AppManager {
    static let shared = AppManager()
    let user : String?
    
    private init() {
        user = UserDefaults.standard.string(forKey: "userName")
    }

    lazy var context: NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()

}

