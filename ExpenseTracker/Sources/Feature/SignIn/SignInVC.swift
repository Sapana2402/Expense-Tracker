//
//  SignInVC.swift
//  ExpenseTracker
//
//  Created by MACM26 on 26/06/25.
//

import UIKit
import CoreData

class SignInVC: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var seconImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var totalBalance: UITextField!
    @IBOutlet weak var incomePerMonth: UITextField!
//    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        startInfiniteMovement()
      
    }
    
    func startInfiniteMovement() {
        moveToRandomPoint(imageViewMove: firstImageView)
        moveToRandomPoint(imageViewMove: seconImageView)
        moveToRandomPoint(imageViewMove: thirdImageView)
        moveToRandomPoint(imageViewMove: fourthImageView)
    }

    func moveToRandomPoint(imageViewMove: UIImageView) {
           let maxX = view.bounds.width - imageViewMove.bounds.width
           let maxY = view.bounds.height - imageViewMove.bounds.height
           let randomX = CGFloat.random(in: 0...maxX)
           let randomY = CGFloat.random(in: 0...maxY)

           UIView.animate(withDuration: 3.0, delay: 0, options: [.curveLinear], animations: {
               imageViewMove.frame.origin = CGPoint(x: randomX, y: randomY)
           }) { _ in
               self.moveToRandomPoint(imageViewMove: imageViewMove)
           }
       }
    
    
    @IBAction func handleSaveData(_ sender: UIButton) {
        if userName.text! != "", totalBalance.text! != "", incomePerMonth.text! != "" {
            addUserData()
        }else{
            let alert = UIAlertController(title: "", message: "All data required!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func addUserData()  {
        let userDetails = User(context: AppManager.shared.context)
        userDetails.nickName = userName.text
        userDetails.totalBalance = Double(totalBalance.text ?? "0") ?? 0.0
        userDetails.incomePerMonth = Double(incomePerMonth.text ?? "0") ?? 0.0
        
        SignInVM.shared.saveToCoreData()
        UserDefaults.standard.set(userName.text, forKey: "userName")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC")

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            window.rootViewController = dashboardVC
            window.makeKeyAndVisible()
        }


        
//        let itemData: [User] = SignInVM.shared.fetch(User.self)
//        UserDefaults.standard.set(userName.text, forKey: "userName")
        
//        let name = UserDefaults.standard.string(forKey: "userName")
//        print("itemmmm",itemData,name!)
    }
    
}
