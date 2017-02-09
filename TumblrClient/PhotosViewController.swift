//
//  PhotosViewController.swift
//  TumblrClient
//
//  Created by Brandon Sanchez on 2/1/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet var photosCollectionView: UICollectionView!
    var posts: [NSDictionary] = []
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tumblrRequest()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        let navigation = navigationController?.navigationBar.topItem
        navigation?.title = "People of New York"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont(name: "AlNile-Bold", size: 20)!, NSForegroundColorAttributeName:UIColor.primary]
        
        
        photosCollectionView.backgroundColor = UIColor.primary
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        photosCollectionView.insertSubview(refreshControl, at: 0)
        refreshControl.tintColor = UIColor.black
        
        let frame = CGRect(x: 0, y: photosCollectionView.contentSize.height, width: photosCollectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        photosCollectionView.addSubview(loadingMoreView!)
        
        var insets = photosCollectionView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        photosCollectionView.contentInset = insets
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        tumblrRequest()
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
                        //self.photosCollectionView.reloadData()
                        print("here")
                    }
                    self.isMoreDataLoading = false
                    self.photosCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.loadingMoreView!.stopAnimating()
                }
        });
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard posts != nil else {return 1}
        
        return posts.count
    }
    
    var imageUrlString: String?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let post = posts[indexPath.row]
        
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            print(imageUrlString)
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
            print("failure unwrapping photos")
        }
        //let imageUrl = URL(string: imageUrlString!)
        guard imageUrlString != nil else {fatalError("error casting URL")}
        print(imageUrlString)
        cell.photoImageView.setImageWith(URL(string: imageUrlString!)!)
        cell.imageUrlString = imageUrlString!
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        imageUrlString = cell.imageUrlString
        //performSegue(withIdentifier: "DetailSegue", sender: cell)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = photosCollectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - photosCollectionView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && photosCollectionView.isDragging) {
                isMoreDataLoading = true
                
                let frame = CGRect(x: 0, y: photosCollectionView.contentSize.height, width: photosCollectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                tumblrRequest()
            }
        }
    }
    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? PhotosDetailViewController,
        imageUrlString != nil else {return}
        
        let indexPath = photosCollectionView.indexPath(for: sender as! UICollectionViewCell)
        let cell = photosCollectionView.cellForItem(at: indexPath!) as! PhotoCell
        
        if segue.identifier == "DetailSegue" {
        detailsVC.imageUrlString = cell.imageUrlString
        }
    }
 

}

extension UIColor {
    static var primary: UIColor { get { return UIColor(red: 147/255, green: 166/255, blue: 177/255, alpha: 1) } }
    static var secondary: UIColor { get { return UIColor(red: 154/255, green: 159/255, blue: 182/255, alpha: 1) } }
}
