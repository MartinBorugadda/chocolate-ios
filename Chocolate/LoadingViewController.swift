//
//  LoadingViewController.swift
//  Chocolate
//
//  Created by AT on 12/5/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit
//import Firebase

class LoadingPageViewController: UIViewController , HolderViewDelegate {
    
    var holderView = HolderView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }
    
    func animateLabel() {
        // 1
        holderView.removeFromSuperview()
        view.backgroundColor = Colors.blue
        
        // 2
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Colors.white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 70.0)
        label.textAlignment = NSTextAlignment.center
        label.text = "Chocolate"
        label.transform = label.transform.scaledBy(x: 0.25, y: 0.25)
        view.addSubview(label)
        
        // 3
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(),
                       animations: ({
                        label.transform = label.transform.scaledBy(x: 4.0, y: 4.0)
                       }), completion: { finished in
                        self.ret()
        })
        addButton()
    }
    
    func addButton() {
        let button = UIButton()
        button.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height)
        button.addTarget(self, action: #selector(LoadingPageViewController.buttonPressed(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func buttonPressed(_ sender: UIButton!) {
        // view.backgroundColor = Colors.white
        // view.subviews.forEach({ $0.removeFromSuperview() })
        // view.subviews.map({ $0.removeFromSuperview() })
        // holderView = HolderView(frame: CGRect.zero)
        // addHolderView()
       // if (FIRAuth.auth()?.currentUser) != nil
       // {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homepage")
            self.present(nextViewController, animated:true, completion:nil)
//        }
//        else
//        {
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginpage")
//            self.present(nextViewController, animated:true, completion:nil)
//            
//        }
        
        
    }
    
    func ret()
    {
        return
    }
}
