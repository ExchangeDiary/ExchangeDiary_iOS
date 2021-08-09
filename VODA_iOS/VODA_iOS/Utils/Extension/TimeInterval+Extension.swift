//
//  TimeInterval+Extension.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import Foundation

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        
        let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = time % 60
        
        return String(format: "%0.2d:%0.2d", seconds, milliseconds)
    }
}
