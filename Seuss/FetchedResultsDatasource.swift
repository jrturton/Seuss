//
//  TableViewController-FetchedResults.swift
//  Seuss
//
//  Created by Richard Turton on 18/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import UIKit
import CoreData

typealias DequeueCell = (tableView: UITableView, indexPath:NSIndexPath) -> UITableViewCell
typealias ConfigureCell = (cell: UITableViewCell, indexPath:NSIndexPath, object:AnyObject!) -> Void

class FetchedResultsDataSource : NSObject, UITableViewDataSource , NSFetchedResultsControllerDelegate {
    var resultsController : NSFetchedResultsController? {
        didSet {
            resultsController?.performFetch(nil)
            resultsController?.delegate = self
            oldValue?.delegate = nil
        }
    }
    
    var configureCell : ConfigureCell! = nil
    var dequeueCell : DequeueCell! = nil
    
    // MARK: Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultsController?.sections?[section] as? NSFetchedResultsSectionInfo)?.numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueCell(tableView:tableView,indexPath:indexPath)
        configureCell(cell:cell, indexPath:indexPath, object:resultsController?.objectAtIndexPath(indexPath))
        return cell
    }

}