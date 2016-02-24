//
//  ViewController.swift
//  Amazon Preis Monitor
//
//  Created by Daniel Müllenborn on 15/01/16.
//  Copyright © 2016 Daniel Müllenborn. All rights reserved.
//

import Cocoa
// import AudioToolbox

class ViewController: NSViewController {
  
  @IBOutlet weak var urlField: NSTextField!
  @IBOutlet weak var tableView: NSTableView!
  
  var data: [[String: String]] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  var urls: [NSURL] = [] {
    didSet {
      timer?.invalidate()
      
      FileHelper.writeConfigFile(urls)
      
      timer = Timer.scheduledTimer(1200) { _ in
        
        self.data.removeAll()
        for url in self.urls {
          if let (name, price) = getPrize(url) {
            let dict: [String: String] = ["Name":name, "Price": price]
            self.data.append(dict)
            //    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
          }
        }
      }
    }
  }
  
  var timer: NSTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    urlField.delegate = self
    
    if let urls = FileHelper.readConfigFile() {
      self.urls = urls
    }
  }
  
  override var representedObject: AnyObject? {
    didSet {
      // Update the view, if already loaded.
    }
  }
}

extension ViewController: NSTextFieldDelegate {
  
  override func controlTextDidChange(notification: NSNotification) {
    if let textField = notification.object as? NSTextField {
      guard let url = NSURL(string: textField.stringValue) where url.host == "www.amazon.de" else { return }
      self.urls.append(url)
      textField.stringValue = ""
    }
  }
}

extension ViewController: NSTableViewDataSource {
  
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return data.count
  }
  
  func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    return 22
  }
  
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

    let cellView = tableView.makeViewWithIdentifier("MainCell", owner: self) as! TableCellView
    
    if let name = data[row]["Name"], price = data[row]["Price"] {
      cellView.row = row
      cellView.dataSource = self
      cellView.leftText.stringValue = name
      cellView.rightText.stringValue = price
      return cellView
    }
    
    return nil
  }
}

extension ViewController: NSTableViewDelegate {
  
  func tableViewSelectionDidChange(notification: NSNotification) {
    
    guard let tableView = notification.object as? NSTableView else { return }
    
    let selectedRow = tableView.selectedRow
    
    if selectedRow >= 0 {
      tableView.deselectRow(selectedRow)
      let url = urls[selectedRow]
      NSWorkspace.sharedWorkspace().openURL(url)
    }
  }

}

