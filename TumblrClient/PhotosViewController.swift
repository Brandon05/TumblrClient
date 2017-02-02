//
//  PhotosViewController.swift
//  TumblrClient
//
//  Created by Brandon Sanchez on 2/1/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var photosCollectionView: UICollectionView!
    var posts: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tumblrRequest()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        let navigation = navigationController?.navigationBar.topItem
        navigation?.title = "People of New York"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont(name: "AlNile-Bold", size: 20)!, NSForegroundColorAttributeName:UIColor.primary]
        
        
        photosCollectionView.backgroundColor = UIColor.primary
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tumblrRequest() {
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        guard let responseFieldDictionary = responseDictionary["response"] as? NSDictionary else {fatalError("error in responseDictionary")}
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.photosCollectionView.reloadData()
                        print("here")
                    }
                    self.photosCollectionView.reloadData()
                }
        });
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard posts != nil else {return 1}
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let post = posts[indexPath.row]
        var imageUrlString: String?
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            print(imageUrlString)
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
            print("failure unwrapping photos")
        }
        
        guard let imageUrl = URL(string: imageUrlString!) else {fatalError("error casting URL")}
        cell.photoImageView.setImageWith(imageUrl)
        
        
        return cell
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

extension UIColor {
    static var primary: UIColor { get { return UIColor(red: 147/255, green: 166/255, blue: 177/255, alpha: 1) } }
    static var secondary: UIColor { get { return UIColor(red: 154/255, green: 159/255, blue: 182/255, alpha: 1) } }
}
