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
        (cell: UITableViewCell, indexPath:NSIndexPath, object:AnyObject!) in
        if let book = object as? Book {
            cell.textLabel.text = book.title
            cell.detailTextLabel?.text = "\(book.year)"
            cell.imageView.image = book.image
        }
    }

 
  
  @IBAction func refresh(sender: AnyObject) {
    displayActivity(2)
  }
  
}