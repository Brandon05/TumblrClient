//
//  PhotosDetailViewController.swift
//  TumblrClient
//
//  Created by Brandon Sanchez on 2/8/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosDetailViewController: UIViewController {

    @IBOutlet var baseView: UIView!
    @IBOutlet var photoImageView: UIImageView!
    var image: UIImage!
    var imageUrlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(baseView)
        photoImageView.setImageWith(URL(string: imageUrlString)!)
        
        self.view.backgroundColor = UIColor.primary
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(_ view: UIView) {
        view.layoutIfNeeded()
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        let shadowPath = UIBezierPath(rect: photoImageView.bounds).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.6
        view.layer.masksToBounds = true
        view.layer.shadowPath = shadowPath
        view.layer.shadowRadius = 6
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
