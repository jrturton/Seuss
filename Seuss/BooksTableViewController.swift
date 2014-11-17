//
//  BooksTableViewController.swift
//  Seuss
//
//  Created by Richard Turton on 13/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import CoreData

class BooksTableViewController: UITableViewController {
  
    var coreDataStack : CoreDataStack! {
        didSet {
            resultsController = coreDataStack?.booksResultController()
        }
    }
    
    var resultsController : NSFetchedResultsController? {
        didSet {
            resultsController?.performFetch(nil)
            tableView.reloadData()
        }
    }
  
    
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return resultsController?.sections?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (resultsController?.sections?[section] as? NSFetchedResultsSectionInfo)?.numberOfObjects ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    
    if let book = resultsController?.objectAtIndexPath(indexPath) as? Book {
        cell.textLabel.text = book.title
        cell.detailTextLabel?.text = "\(book.year)"
        cell.imageView.image = book.image
    }
    
    return cell
  }
  
  @IBAction func refresh(sender: AnyObject) {
    displayActivity(2)
  }
  
}