//
//  TrueOrientation.swift
//  TrueOrientation
//
//  Created by Mauk on 13/02/18.
//  Copyright © 2018 Mauricio Lorenzetti. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

class TrueOrientation : NSObject {
    
    //handle device orientation when locked
    private var motionManager = CMMotionManager()
    
    public var updateInterval:TimeInterval = 0.1
    private var timer:Timer? = nil
    
    private var initialX:Double? = nil
    
    public private(set) var currentOrientation:UIDeviceOrientation = .unknown {
        willSet(orientation) {
            if currentOrientation != .unknown {
                self.changed()
            }
        }
    }
    
    var callback:() -> ()?
    
    init(whenOrientationChanges:@escaping () -> ()) {
        callback = whenOrientationChanges
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates()
        super.init()
        timer = Timer(fire: Date(), interval: updateInterval, repeats: true, block: { (timer) in
            // Get the accelerometer data.
            if let data = self.motionManager.accelerometerData {
                if self.initialX == nil {
                    self.initialX = data.acceleration.x
                    if  abs(self.initialX!) > 0.7 &&
                        abs(self.initialX!) < 1.0 {
                        if self.initialX! > 0 {
                            self.currentOrientation = .landscapeLeft
                        } else {
                            self.currentOrientation = .landscapeRight
                        }
                    } else {
                        self.currentOrientation = .portrait
                    }
                } else {
                    if  abs(data.acceleration.x) > 0.7 &&
                        abs(data.acceleration.x) < 1.0 &&
                        self.currentOrientation == .portrait {
                        if abs(data.acceleration.x) > 0 {
                            self.currentOrientation = .landscapeLeft
                        } else {
                            self.currentOrientation = .landscapeRight
                        }
                    }
                    if abs(data.acceleration.x) < 0.3 &&
                       self.currentOrientation == .landscapeLeft ||
                       self.currentOrientation == .landscapeRight {
                        self.currentOrientation = .portrait
                    }
                }
            }
        })
        RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
        
    }
    
    func changed() {
        callback()
    }
    
}
