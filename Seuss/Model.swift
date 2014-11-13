//
//  Model.swift
//  Seuss
//
//  Created by Richard Turton on 13/11/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit

struct Book {
  let title : String
  let year : Int
  let image : UIImage
}

func createBooks() -> [Book] {
  let seedURL = NSBundle.mainBundle().URLForResource("books", withExtension: "json")
  let data = NSData(contentsOfURL: seedURL!)
  let seedBooks = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as [[String : AnyObject]]
  
  let books : [Book] = seedBooks.map {
    return Book(
      title: $0["title"] as String,
      year: $0["year"] as Int,
      image: UIImage(named: $0["image"] as String)!)
  }
  
  return books
}

struct Character {
  let name : String
  let image : UIImage
  let books : [Book]
}

