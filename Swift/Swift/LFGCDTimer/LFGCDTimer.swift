//
//  LFGCDTimer.swift
//  LFGCDTimer
//
//  Created by ArcherLj on 2019/8/7.
//  Copyright © 2019 ArcherLj. All rights reserved.
//

import Foundation

open class LFGCDTimer: NSObject {
    
    var timer: DispatchSourceTimer?
    
    open class func scheduledTimer(withTimeInterval interval: Int, repeats: Bool, block: @escaping () -> Void) -> LFGCDTimer {
        let gcdTimer = LFGCDTimer()
        
        let queue = DispatchQueue.main
        gcdTimer.timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        let deadline = DispatchTime(uptimeNanoseconds: UInt64(0 * NSEC_PER_SEC))
        let repeatingInterval = DispatchTimeInterval.seconds(interval)
        let leeway = DispatchTimeInterval.seconds(0)
        gcdTimer.timer?.schedule(deadline: deadline, repeating: repeatingInterval, leeway: leeway)
        
        
        gcdTimer.timer?.setEventHandler { [weak gcdTimer] in
            
            block()
            if (!repeats) {
                gcdTimer?.invalidate()
            }
        }
        
        gcdTimer.timer?.resume()
        return gcdTimer
    }
    
    open class func scheduledTimer(timeInterval ti: Int, target aTarget: AnyObject, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> LFGCDTimer {
        
        let gcdTimer = LFGCDTimer()
        
        let queue = DispatchQueue.main
        gcdTimer.timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        let deadline = DispatchTime(uptimeNanoseconds: UInt64(0 * NSEC_PER_SEC))
        let repeatingInterval = DispatchTimeInterval.seconds(ti)
        let leeway = DispatchTimeInterval.seconds(0)
        gcdTimer.timer?.schedule(deadline: deadline, repeating: repeatingInterval, leeway: leeway)
        
        
        gcdTimer.timer?.setEventHandler { [weak gcdTimer, weak aTarget] in
            
            aTarget?.performSelector(inBackground: aSelector, with: userInfo)
            if (!yesOrNo) {
                gcdTimer?.invalidate()
            }
        }
        
        gcdTimer.timer?.resume()
        return gcdTimer
    }
    
    open func invalidate() {
        timer?.cancel()
        timer = nil
    }
}
