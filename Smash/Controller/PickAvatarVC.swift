//
//  PickAvatarVC.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/1/21.
//

import UIKit

class PickAvatarVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var moodSegment: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var avatarType:AvatarType = .light
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func backPressed(_ sender: Any) {
   dismiss(animated: true)
    }
    @IBAction func moodStateChanged(_ sender: Any) {
        if moodSegment.selectedSegmentIndex == 0{
            avatarType = .light
        }else{
            avatarType = .dark
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columnCount:CGFloat = 3
        if UIScreen.main.bounds.width > 320{
            columnCount = 4
        }
        
        let gap:CGFloat = 10
        let padding:CGFloat = 40
        
        let cellDimention = ((collectionView.bounds.width - padding) - (columnCount - 1) * gap) / columnCount
        
        return CGSize(width: cellDimention, height: cellDimention)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if avatarType == .dark{
            AuthService.instance.userData.avatarName = "dark\(indexPath.row)"
        }else{
            AuthService.instance.userData.avatarName = "light\(indexPath.row)"
        }
        dismiss(animated: true)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell{
            cell.configureCell(indexPath: indexPath, avatarType: avatarType)
            return cell
        }else{
            return AvatarCell()
        }
    }

}
