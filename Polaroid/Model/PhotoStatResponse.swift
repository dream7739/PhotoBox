//
//  PhotoStatResponse.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import Foundation

struct PhotoStatResponse: Decodable {
    let id: String
    let downloads: Download
    let views: Views
}

struct Download: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [HistoricalValue]
}

struct HistoricalValue: Decodable {
    let date: String
    let value: Int
}

struct Views: Decodable {
    let total: Int
    let historical: Historical
}

