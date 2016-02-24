//
//  FileHelper.swift
//  Amazon Preis Monitor
//
//  Created by Daniel Müllenborn on 16/01/16.
//  Copyright © 2016 Daniel Müllenborn. All rights reserved.
//

import Foundation


final class FileHelper {
  
  static let fileManager = NSFileManager.defaultManager()

  static var configPath: NSURL {
    let URLs = fileManager.URLsForDirectory(.ApplicationSupportDirectory, inDomains:.UserDomainMask)
    var applicationSupportDirectory = URLs[0] as NSURL
    applicationSupportDirectory = applicationSupportDirectory.URLByAppendingPathComponent("Amazon Preis Monitor")
    do {
      try fileManager.createDirectoryAtURL(applicationSupportDirectory, withIntermediateDirectories: true, attributes: nil)
    } catch let e as NSError {
      print(e.localizedDescription)
    }
    return applicationSupportDirectory.URLByAppendingPathComponent("urls.cache")
  }
  
  static func readConfigFile() -> [NSURL]? {
    guard let urls = NSArray(contentsOfURL: configPath) as? [String] else { return nil }
    return urls.flatMap {NSURL(string: $0)}
  }
  
  static func writeConfigFile(list: [NSURL]) -> Bool? {
    let list = list.map {$0.absoluteString} as NSArray
    return list.writeToURL(configPath, atomically: true)
  }
  
}
