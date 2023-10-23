//
//  Date+Extension.swift
//  RickAndMorty
//
//  Created by Kunal Tyagi on 19/10/23.
//

import Foundation

extension String {
    func getFormattedDate() -> String {
        let dateFormatterGet = ISO8601DateFormatter()
        dateFormatterGet.formatOptions = .withFullDate
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }
        return ""
    }
}
