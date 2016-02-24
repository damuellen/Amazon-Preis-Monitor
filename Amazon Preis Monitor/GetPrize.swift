//
//  GetPrize.swift
//  Amazon Preis Monitor
//
//  Created by Daniel Müllenborn on 15/01/16.
//  Copyright © 2016 Daniel Müllenborn. All rights reserved.
//

import Foundation
import Kanna

func getPrize(url: NSURL)-> (String, String)? {
  
  guard url.host == "www.amazon.de" else { return nil }
  guard let ASIN = url.pathComponents?[3] else { return nil }
  
  let baseURLstring = "http://www.amazon.de/gp/dp/"
  
  let url = NSURL(string: baseURLstring + ASIN)!
  
  if let html = try? NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding),
    doc = Kanna.HTML(html: html as String, encoding: NSUTF8StringEncoding),
    title = doc.xpath("//span[@id='productTitle']").text,
    prize = doc.xpath("//span[@id='priceblock_ourprice']").text {
    return (title, prize)
  }
  return nil
}