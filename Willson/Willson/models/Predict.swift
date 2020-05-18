//
//  Predict.swift
//  Willson
//
//  Created by JHKim on 2020/05/18.
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
    let category, experience: String
    let willsonerIdx, label: Int
    
    enum CodingKeys: String, CodingKey {
        case category, experience
        case willsonerIdx = "willsoner_idx"
        case label
    }
}
