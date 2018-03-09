//
//  LoginFromController.swift
//  iOSDevelopersCourse
//
//  Created by Natalya on 17/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    
    let logOut = LogOutRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func logOut(segue: UIStoryboardSegue) {
        logOut.logOut()
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        logIn()
    }
    
    func logIn() {
        let alertController = UIAlertController(title: "Log in", message: "Are you sure you want to log in through VK account?", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.performSegue(withIdentifier: "showAuthorization", sender: self)
        })
        let noButton = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        present(alertController, animated: true)
    }
}
