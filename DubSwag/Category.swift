//
//  Category.swift
//  DubSwag
//
//  Created by Talha Babar on 8/6/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit


class Category: NSObject {
    let categoryId: String?
    let categoryName: String?
    
    init(category: PFObject) {
      self.categoryName = category["categoryName"] as? String
      self.categoryId = category.objectId
    }
    
}
