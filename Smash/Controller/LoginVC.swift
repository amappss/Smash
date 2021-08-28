//
//  LoginVC.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/30/21.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var activityIndc: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndc.isHidden = true
    }
    
    func showLoading(){
        activityIndc.isHidden = false
        activityIndc.startAnimating()
    }
    
    func hideLoading(){
        activityIndc.isHidden = true
        activityIndc.stopAnimating()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        
        guard let email = usernameField.text else { return}
        guard let pass = passwordField.text else { return}
        showLoading()
        let user = User()
        user.email = email
        user.password = pass
        AuthService.instance.loginUser(user: user) { (state) in
            if state {
                AuthService.instance.findUser { (state) in
                    if state{
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: NOTI_USER_CHANGED,object:nil)
                        self.hideLoading()
                    }else{
                        self.hideLoading()
                    }
                }
            }else{
                self.hideLoading()
            }
        }
    }
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_SIGNUP, sender: nil)
    }

}
