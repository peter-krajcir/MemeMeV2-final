//
//  SentMemesCollectionViewController.swift
//  MemeMeV1
//
//  Created by Petrik on 22/09/15.
//  Copyright © 2015 Peter Krajcir. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initial flow layout settings for the Collection view based on the device rotation
        setFlowLayout()
        
        // add listener for device rotation notification so we can set different flow layout for
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceRotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func deviceRotated() {
        // set the flow layout for the Collection view based on the device rotation
        setFlowLayout()
    }
    
    deinit {
        // remove listener for device rotation notification
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func setFlowLayout() {
        let space: CGFloat = 3.0
        var dimension: CGFloat = 0.0
        
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            dimension = (self.view.frame.size.width - (5 * space)) / 6.0
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView!.reloadData()
    }

    @IBAction func createNewMeme(sender: AnyObject) {
        // user hits 'plus' icon in the top right corner
        let memeController = storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        
        presentViewController(memeController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // when user selects row in table view, display it in Meme Detail View
        if (segue.identifier == "MemeDetailSegue") {
            let memeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            if let indexPath = collectionView?.indexPathsForSelectedItems() {
                let selectedMeme = memes[indexPath[0].item]
                memeDetailViewController.meme = selectedMeme
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCellId", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
    
        return cell
    }
}
