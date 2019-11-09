//
//  ViewController.swift
//  uchatTutApp
//
//  Created by Vadim  Gorbachev on 07.11.2019.
//  Copyright © 2019 Vadim  Gorbachev. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let segueIdentifier = "chatSegue"

  // MARK: IBOutlets
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
               
        warnLabel.alpha = 0
               
        Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        })
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           emailTextField.text = ""
           passwordTextField.text = ""
       }
    
    
    // MARK: IBActions
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
                   displayWarningLabel(withText: "Info is incorrect")
                   return
        }
               
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
                if error != nil {
                    self?.displayWarningLabel(withText: "Error occured")
                    return
                }
                   
                if user != nil {
                    self?.performSegue(withIdentifier: "chatSegue", sender: nil)
                    return
                }
                   
                self?.displayWarningLabel(withText: "No such user")
        })
        
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if user != nil {
                    
                } else {
                    print("user is not created")
                }
            } else {
                print(error!.localizedDescription)
            }
            
        })
        
    }
    
    // MARK: moving keyboard logic
    @objc func keyboardbDidShow(notification: Notification) {
           guard let userInfo = notification.userInfo else { return }
           let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
           
           //(self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
           //(self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
           
       }
       
    @objc func keyboardbDidHide() {
           (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
       }
       
    // MARK: warning label logic
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
}

/// пупа и лупа. кто что получит?

