//
//  AvatarCell.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/1/21.
//

import UIKit

enum AvatarType{
    case light, dark
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }
    
    func configureCell(indexPath:IndexPath,avatarType:AvatarType){
        if(avatarType == .dark){
            avatarImg.image = UIImage(named: "dark\(indexPath.row)")
            layer.backgroundColor = UIColor.lightGray.cgColor
        }else{
            avatarImg.image = UIImage(named: "light\(indexPath.row)")
            layer.backgroundColor = UIColor.darkGray.cgColor
        }
    }
    
    func setLayout(){
        self.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
