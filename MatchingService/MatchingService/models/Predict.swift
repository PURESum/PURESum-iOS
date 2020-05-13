//
//  Predict.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/06.
//  Copyright © 2020 zhi. All rights reserved.
//

import Foundation

// MARK: - Predict
struct Predict: Codable {
    let code: String
    let data: DataClass
    let status: Int
}

// MARK: - DataClass
struct DataClass: Codable {
    let predict: PredictClass
    let time, version: String
}

// MARK: - PredictClass
struct PredictClass: Codable {
    let category: String
    let counselor: [Counselor]
    let label: Int
    let percent, text: String
}

// MARK: - Counselor
struct Counselor: Codable {
    let category, data: String
    let index, label: Int
}
