//
//  CircleImage.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/1/21.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        setUp()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }
    
    func setUp(){
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.clipsToBounds = true
    }
}
