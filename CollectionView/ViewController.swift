//
//  ViewController.swift
//  CollectionView
//
//  Created by ReasonAmu on 11/10/16.
//  Copyright © 2016 ReasonAmu. All rights reserved.
//

import UIKit

class FooterCustom : UICollectionReusableView {
    
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
}

class ViewController: UIViewController {
    
    
    //--
    var listPhoto  = [UIImage]()
    
    
    
    
    
    var footerView : FooterCustom?
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionview: UICollectionView!
    var check : Bool = true
    var prefesh =  UIRefreshControl()
    var listData = [Int]()
    
    var customView : UIView!
    var labelArray = [UILabel]()
    
    func loadCustomRefreshContents(){
        
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        customView  = refreshContents?[0] as! UIView
        customView.frame = prefesh.bounds
        
        for (index, _) in customView.subviews.enumerated(){
            labelArray.append(customView.viewWithTag(index + 100) as! UILabel)
        }
    
        
        prefesh.addSubview(customView)
        
    }
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var timer : Timer!
    
    func doSomething(){
        
        timer =  Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(finishRefesh), userInfo: nil, repeats: true)
    }
    
    func finishRefesh(){
        
        prefesh.endRefreshing()
        timer.invalidate()
        
    }
    
    func animateStep1(){
        isAnimating = true
        //-- xoay label
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.labelArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: -1).rotated(by: CGFloat(M_PI_2))
            self.labelArray[self.currentLabelIndex].textColor = self.getTextColor()
        }, completion: { (finish) in
            
            UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.labelArray[self.currentLabelIndex].transform = CGAffineTransform.identity
                self.labelArray[self.currentLabelIndex].textColor = UIColor.black
            }, completion: { (finish) in
                self.currentLabelIndex += 1
                if self.currentLabelIndex < self.labelArray.count{
                    self.animateStep1()
                }else{
                    self.animateStep2()
                }
            })
            
        })
    }
    
    
    func animateStep2(){
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            //-- scale label 1.5
            self.labelArray[0].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelArray[1].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelArray[2].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelArray[3].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelArray[4].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelArray[5].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelArray[6].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { finish in
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.labelArray[0].transform = CGAffineTransform.identity
                self.labelArray[1].transform = CGAffineTransform.identity
                self.labelArray[2].transform = CGAffineTransform.identity
                self.labelArray[3].transform = CGAffineTransform.identity
                self.labelArray[4].transform = CGAffineTransform.identity
                self.labelArray[5].transform = CGAffineTransform.identity
                self.labelArray[6].transform = CGAffineTransform.identity
                
            }, completion: { finish in
                if self.prefesh.isRefreshing {
                    self.currentLabelIndex = 0
                    self.animateStep1()
                }else{
                    self.isAnimating = false
                    self.currentLabelIndex = 0
                    for (index,_) in self.labelArray.enumerated() {
                        self.labelArray[index].textColor = UIColor.black
                        self.labelArray[index].transform = CGAffineTransform.identity
                    }
                }
                
            })
            
        })
    }
    
    func getTextColor() -> UIColor {
        var colorArray: [UIColor] = [UIColor.magenta , UIColor.brown , UIColor.yellow , UIColor.red , UIColor.green, UIColor.blue , UIColor.orange]
        
        
        //-- gan lai bien dem color
        if currentColorIndex == colorArray.count {
            
            currentColorIndex = 0
        }
        
        let returnColor = colorArray[currentColorIndex]
        
        currentColorIndex += 1
        return returnColor
    }
    
    let ovanView : UIView = {
        let views = UIView()
        views.backgroundColor = UIColor.red
        views.translatesAutoresizingMaskIntoConstraints  = false
        return views
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionview.delegate = self
        collectionview.dataSource = self
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        prefesh.tintColor = UIColor.red
        collectionview.addSubview(prefesh)
        collectionview.allowsMultipleSelection = true // không đc reloadData khi sử dụng
        
        
        collectionview.register( UINib(nibName: "CellCollectionView", bundle: nil), forCellWithReuseIdentifier: "CellCustom")
        
        loadCustomRefreshContents()
        
        layout.sectionInset = UIEdgeInsetsMake(0, 50, 50, 50)
        listData = [1,2,3,4,5]
        
    }
    
    
    
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.invalidateLayout()
    }
    
    
    
    
    
}

private extension ViewController {
    
    //    func photoForIndexPath (_ indexPath : IndexPath) {
    //        return listPhoto[indexPath as NSIndexPath]
    //    }
}


extension ViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECT ")
        listPhoto.append(UIImage(named: "t1.jpg")!)
        print(listPhoto.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        
        print("GOI SAU")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("MOVE")

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 100 , height: 200)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if prefesh.isRefreshing {
            
            layout.invalidateLayout()
            if !isAnimating {
                doSomething()
                animateStep1()
                
            }
        }
        
    }
    
    
  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            check = false
            listData.append(contentsOf: [6,7,8,9,10])
            collectionview.reloadData()
            footerView?.indicatorLoading.startAnimating()
            //check = true
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let viewFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
        // configure footer view
        
        return viewFooter
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let size = CGSize(width: 0, height: 0)
        
        if check == false {
            return CGSize(width: 50, height: 50)
        }
        
        return size
    }
    
    
}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCustom", for: indexPath) as! CellCollectionView
        cell.imageViews.image = UIImage(named: "t1.jpg")
        cell.setupViews()
        return cell
    }
}




//class DetailsPhotosAlbumCell: UICollectionViewCell {
//    
//    @IBOutlet weak var photoImageView: UIImageView!
//    @IBOutlet weak var statusSelectImageView: UIImageView!
//    
//    override var selected: Bool {
//        didSet {
//            if self.selected {
//                self.alpha = 0.7
//                self.statusSelectImageView.hidden = false
//            }
//            else {
//                self.alpha = 1.0
//                self.statusSelectImageView.hidden = true
//            }
//        }
//    }
//}

