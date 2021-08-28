//
//  SignupVC.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/30/21.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Vars
    var avatarBKColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.autocorrectionType = .no
        activityIndicator.isHidden = true
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let name = AuthService.instance.userData.avatarName{
            avatarImg.image = UIImage(named: name)
            
            if avatarBKColor == nil{
                if(name.contains("dark")){
                    avatarImg.backgroundColor = UIColor.lightGray
                }else{
                    avatarImg.backgroundColor = UIColor.darkGray
                }
            }
        }
       
    }
    
    @IBAction func changeAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR, sender: nil)
    }
    @IBAction func generateRandomBKPressed(_ sender: Any) {
        generateColor()
    }
    
    func generateColor(){
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        AuthService.instance.userData.avatarColor = "[\(r),\(g),\(b)]"
        avatarBKColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        UIView.animate(withDuration: 0.3){
            self.avatarImg.backgroundColor = self.avatarBKColor
        }
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    func showActivityIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        guard let username = usernameField.text, usernameField.text != "" else {return}
        guard let email = emailField.text, emailField.text != "" else {return}
        guard let pass = passwordField.text, passwordField.text != "" else {return}
        
        showActivityIndicator()
        
        let avatarName = AuthService.instance.userData.avatarName ?? "profileDefault"
        let avatarColor = AuthService.instance.userData.avatarColor ?? "[0.5,0.5,0.5]"

        let user:User = User()
        user.username = username
        user.email = email
        user.password = pass
        user.avatarName = avatarName
        user.avatarColor = avatarColor
        
        print(user)

        AuthService.instance.registerUser(user:user ) { (res) in
            if res{
                AuthService.instance.loginUser(user: user) { (res) in
                    if res {
                        AuthService.instance.createAccount(userData: user) { (res) in
                            if res{
                                AuthService.instance.findUser { (res) in
                                    if res{
                                            print("Successfully logged in")
                                            self.performSegue(withIdentifier: UNWIND_TO_CHANNEL,sender: nil)
                                            NotificationCenter.default.post(name: NOTI_USER_CHANGED, object: nil)
                                    }
                                    self.stopActivityIndicator()

                                }
                            }
                        }
                    }else{
                        self.stopActivityIndicator()
                    }
                }
            }else{
                self.stopActivityIndicator()
            }
        }
    }
    
     
    func stopActivityIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    
}
