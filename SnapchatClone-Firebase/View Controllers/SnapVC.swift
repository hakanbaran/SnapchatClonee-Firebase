//
//  SnapVC.swift
//  SnapchatClone-Firebase
//
//  Created by Hakan Baran on 5.11.2022.
//

import UIKit
import ImageSlideshow


class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    
    
    var imputArray = [SDWebImageSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let snap = selectedSnap {
            
            timeLabel.text = "Time Left: \(snap.timeDifference) hour"
            
            for imageUrl in snap.imageUrlArray {
                
                imputArray.append(SDWebImageSource(urlString: imageUrl)!)
                
                
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            
            imageSlideShow.backgroundColor = UIColor.white
            imageSlideShow.setImageInputs(imputArray)
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            
            
            let pageInticator = UIPageControl()
            pageInticator.currentPageIndicatorTintColor = UIColor.lightGray
            pageInticator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageInticator
            
            imageSlideShow.pageIndicator = LabelPageIndicator()
             
            
            
            
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
            
            
        }
        
        
    }

    

}
