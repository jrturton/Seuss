//
//  Book.swift
//  Seuss
//
//  Created by Richard Turton on 17/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Book: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var year: NSNumber
    @NSManaged var imageName: String
    
    var image : UIImage {
        return UIImage(named:imageName)!
    }

}

func createBooks(context : NSManagedObjectContext) {
    let seedURL = NSBundle.mainBundle().URLForResource("books", withExtension: "json")
    let data = NSData(contentsOfURL: seedURL!)
    let seedBooks = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as [[String : AnyObject]]
    
    for bookDict in seedBooks {
        let book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: context) as Book
        book.title = bookDict["title"] as String
        book.year = bookDict["year"] as Int
        book.imageName = bookDict["image"] as String
    }
}
