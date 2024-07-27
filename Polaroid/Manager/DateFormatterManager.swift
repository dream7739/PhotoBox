//
//  DateFormatterManager.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import Foundation

enum DateFormatterManager {
    enum DateFormat: String {
        case yyyyMd = "yyyy년 M월 d일"
    }
    
    static var basicDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yyyyMd.rawValue
        return dateFormatter
    }
}
