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
    let status: Int
    let code: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let predict: PredictClass
    let time, version: String
}

// MARK: - PredictClass
struct PredictClass: Codable {
    let category: String
    let label: Int
    let percent, text: String
}
