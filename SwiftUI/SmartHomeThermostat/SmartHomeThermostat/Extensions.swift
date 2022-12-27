//
//  Extensions.swift
//  SmartHomeThermostat
//
//  Created by 富永開陽 on 2022/10/26.
//

import Foundation
import SwiftUI

extension ThermometerView {
    
    func calculateAngle(centerPoint: CGPoint, endPoint: CGPoint) -> CGFloat {
        let radians = atan2(endPoint.x - centerPoint.x, centerPoint.y - endPoint.y)
        let degrees = 180 + (radians * 180 / .pi)
        
        return degrees
    }
    
}
