//
//  SentMemesTableViewController.swift
//  MemeMeV1
//
//  Created by Petrik on 22/09/15.
//  Copyright © 2015 Peter Krajcir. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCellId", forIndexPath: indexPath)

        cell.textLabel?.text = memes[indexPath.row].topText
        cell.detailTextLabel?.text = memes[indexPath.row].bottomText
        cell.imageView?.image = memes[indexPath.row].image

        return cell
    }

    @IBAction func createNewMeme(sender: AnyObject) {
        let memeController = storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        
        presentViewController(memeController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MemeDetailSegue") {
            // when user selects row in table view, display it in Meme Detail View
            let memeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedMeme = memes[indexPath.row]
                memeDetailViewController.meme = selectedMeme
            }
        }
    }


}
