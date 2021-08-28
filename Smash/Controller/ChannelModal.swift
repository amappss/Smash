//
//  ChannelModal.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/3/21.
//

import UIKit

class ChannelModal: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        bgView.addGestureRecognizer(closeRecognizer)
    }
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = nameField.text , nameField.text != "" else { return }
        guard let desc = descriptionField.text  else { return }
        SocketServices.instance.addChannel(channel: Channel(_id: "", description: desc, name: name))
        close()
    }
    @IBAction func closePressed(_ sender: Any) {
        close()
    }
}
