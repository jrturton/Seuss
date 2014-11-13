//
//  BooksTableViewController.swift
//  Seuss
//
//  Created by Richard Turton on 13/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController {
  
  var books : [Book]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    books = createBooks()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    
    let book = books[indexPath.row]
    
    cell.textLabel.text = book.title
    cell.detailTextLabel?.text = "\(book.year)"
    cell.imageView.image = book.image
  
    return cell
  }
  
  @IBAction func refresh(sender: AnyObject) {
    displayActivity(2)
  }
  
  
}
