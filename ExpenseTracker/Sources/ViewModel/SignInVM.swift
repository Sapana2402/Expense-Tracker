//
//  SIgnInVM.swift
//  ExpenseTracker
//
//  Created by MACM26 on 27/06/25.
//

import CoreData
import UIKit

struct SignInVM {
    
    static let shared = SignInVM()

    
    init() {
       
    }
    
    func saveToCoreData() {
        do{
            print("Saved!!!!")
            try AppManager.shared.context.save()
        }catch{
            fatalError("Facing issue in save context!")
            return
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let request = NSFetchRequest<T>(entityName: entityName)
        
        do {
            let items = try AppManager.shared.context.fetch(request)
            return items
        } catch {
            print("❌ Failed to fetch \(entityName): \(error)")
            return []
        }
    }

    
}
