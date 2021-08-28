//
//  ColorHelper.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/2/21.
//

import Foundation

class ColorHelper{
    
    static func convertStringToColor(stringColor:String) -> UIColor{
        // format "[0.5,0.5,0.5]"
        let defaultColor = UIColor.darkGray
        
        let scanner = Scanner(string: stringColor)
        
        let skipper = CharacterSet(charactersIn: "[], ")
        let devider = CharacterSet(charactersIn: ",")
            
        scanner.charactersToBeSkipped = skipper
        
        var r,b,g :String?
        
        r =  scanner.scanUpToCharacters(from: devider)
        b =  scanner.scanUpToCharacters(from: devider)
        g =  scanner.scanUpToCharacters(from: devider)
        
        guard let rUnwrapped = Float(r ?? "") else { return defaultColor}
        guard let bUnwrapped = Float(b ?? "") else { return defaultColor}
        guard let gUnwrapped = Float(g ?? "") else { return defaultColor}
        
        
        return UIColor(red: CGFloat(rUnwrapped), green: CGFloat(bUnwrapped), blue: CGFloat(gUnwrapped), alpha: 1.0)

    }

}
