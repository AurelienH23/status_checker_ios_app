//
//  Tools.swift
//  StatusChecker
//
//  Created by Aurélien Haie on 24/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

class Tools: NSObject {
    
    static func getTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let min = Calendar.current.component(.minute, from: Date())
        var minute: String
        if min < 10 {
            minute = "0\(min)"
        } else {
            minute = "\(min)"
        }
        return "\(hour):\(minute)"
    }
    
}
