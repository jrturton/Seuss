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
            let resultsController = coreDataStack?.booksResultController()
            fetchedResultsDataSource = FetchedResultsDataSource()
            fetchedResultsDataSource.tableView = tableView
            fetchedResultsDataSource.resultsController = resultsController
            fetchedResultsDataSource.dequeueCell = dequeueCell
            fetchedResultsDataSource.configureCell = configureCell
            tableView.dataSource = fetchedResultsDataSource
            tableView.reloadData()
        }
    }
    
    var fetchedResultsDataSource : FetchedResultsDataSource! = nil
    
    let dequeueCell : DequeueCell = {
        (tableView: UITableView, indexPath:NSIndexPath) in
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }

    let configureCell : ConfigureCell = {
        (cell : UITableViewCell, indexPath:NSIndexPath, object:AnyObject!) in
        let bookCell = cell as? BookCell
        if let book = object as? Book {
            bookCell?.titleLabel.text = book.title
            bookCell?.yearLabel.text = "\(book.year)"
            bookCell?.coverImage.image = book.image
            bookCell?.ratingLabel.text = book.ratingString
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath == tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.beginUpdates()
            tableView.endUpdates()
            return nil
        }
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == tableView.indexPathForSelectedRow() {
            return 160.0
        } else {
            return 80.0
        }
    }

 // MARK: Actions
  
  @IBAction func refresh(sender: AnyObject) {
    displayActivity(2)
  }
  
}