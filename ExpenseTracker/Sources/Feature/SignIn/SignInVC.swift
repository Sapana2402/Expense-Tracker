//
//  SignInVC.swift
//  ExpenseTracker
//
//  Created by MACM26 on 26/06/25.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var seconImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startInfiniteMovement()
        // Do any additional setup after loading the view.
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
               // Recursively keep moving
               self.moveToRandomPoint(imageViewMove: imageViewMove)
           }
       }
}
