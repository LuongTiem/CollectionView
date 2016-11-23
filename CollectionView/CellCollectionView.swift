//
//  CellCollectionView.swift
//  CollectionView
//
//  Created by ReasonAmu on 11/15/16.
//  Copyright © 2016 ReasonAmu. All rights reserved.
//

import UIKit

class CellCollectionView: UICollectionViewCell {

    @IBOutlet weak var imageViews: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViews.contentMode = .scaleAspectFit
        
        
    }
    
    let views : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    
    //-- func cập nhật lại subview trong cell
    override func layoutSubviews() {
        super.layoutSubviews()
        views.layer.cornerRadius = views.frame.width/2
        views.layer.masksToBounds = true
        views.isHidden = true
        
        setupLayerShadows()
    }
    
 
    //-- setup layer shadow View !!! 
    
    func setupLayerShadows(){
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.8
        
        
    }
    
    func setupViews() {
        self.addSubview(views)
        views.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        views.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        views.heightAnchor.constraint(equalToConstant: 30).isActive = true
        views.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
 
    
    
    //MARK: - THUC HIEN SELECT OR NONE
    override var isSelected: Bool {
        didSet{
//            print("Selected")
            
            imageViews.layer.borderWidth = isSelected ? 10 : 0
            imageViews.layer.borderColor = UIColor.red.cgColor
            
            if isSelected == true {
                views.isHidden = false
            }else{
                views.isHidden = true
            }
  
        }
    }
    

}
