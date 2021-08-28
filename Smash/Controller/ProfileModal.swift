//
//  ProfileModal.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/2/21.
//

import UIKit

class ProfileModal: UIViewController {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var emailTxt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        let userData = AuthService.instance.userData
        if let avName = userData.avatarName{
            profileImg.image = UIImage(named: avName)
        }
        if let avColor = userData.avatarColor{
            profileImg.backgroundColor = ColorHelper.convertStringToColor(stringColor: avColor)
        }
        if let user = userData.username{
            usernameTxt.text = user
        }
        if let email = userData.email{
            emailTxt.text = email
        }
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeModule))
        bkView.addGestureRecognizer(closeTap)
    }
    
    @objc func closeModule(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutPressed(_ sender: Any) {
        AuthService.instance.logout()
        dismiss(animated: true, completion: nil)
    }
    
}
