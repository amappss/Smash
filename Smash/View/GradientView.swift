//
//  GradientView.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/29/21.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var startColor:UIColor = #colorLiteral(red: 0.231372549, green: 0.2117647059, blue: 0.7921568627, alpha: 1){
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var endColor:UIColor = #colorLiteral(red: 0.4901960784, green: 0.7137254902, blue: 0.8039215686, alpha: 1){
        didSet{
            layoutIfNeeded()
        }
    }

    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor,endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }

}
