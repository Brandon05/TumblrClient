//
//  PhotoCell.swift
//  TumblrClient
//
//  Created by Brandon Sanchez on 2/1/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet var photoImageView: UIImageView!
    var imageUrlString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImageView.layoutIfNeeded()
        
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 6
        let shadowPath = UIBezierPath(rect: photoImageView.bounds).cgPath
        photoImageView.layer.shadowColor = UIColor.black.cgColor
        photoImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        photoImageView.layer.shadowOpacity = 0.6
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.shadowPath = shadowPath
        photoImageView.layer.shadowRadius = 6
    }
    
    

}
