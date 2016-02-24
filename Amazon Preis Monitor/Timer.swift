//
//  Timeout.swift
//  Fritz TR064
//
//  Created by Daniel Müllenborn on 27/10/15.
//  Copyright © 2015 Daniel Müllenborn. All rights reserved.
//

import Foundation

class Timer {
  
  class CallbackHolder  {
    
    var callback: (NSTimer) -> Void
    
    init(callback: (NSTimer) -> Void) {
      self.callback = callback
    }

    @objc func fired(timer: NSTimer){
      callback(timer)
    }

  }

  class func scheduledTimer(timeInterval: NSTimeInterval, repeats: Bool = true, actions: (NSTimer) -> Void) -> NSTimer {
    let holder = CallbackHolder(callback: actions)
    let timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: holder, selector: Selector("fired:"), userInfo: nil, repeats: repeats)
    actions(timer)
    return timer
  }
  
}