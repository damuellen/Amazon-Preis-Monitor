//
//  TableViewCell.swift
//  Amazon Preis Monitor
//
//  Created by Daniel Müllenborn on 23/02/16.
//  Copyright © 2016 Daniel Müllenborn. All rights reserved.
//

import AppKit

class TableCellView: NSTableCellView {
  
  weak var dataSource: NSTableViewDataSource!
  
  var row: Int!
  
  @IBOutlet weak var leftText: NSTextField!
  
  @IBOutlet weak var rightText: NSTextField!
  
  @IBAction func trash(sender: NSButton) {
    
    let vc = dataSource as! ViewController
    vc.urls.removeAtIndex(row)
  }
  
}
