//
//  Food.swift
//  NoomFood
//
//  Created by Scott Marchington on 10/1/21.
//

import Foundation

struct Food: Codable {
    let id: Int
    let brand: String
    let name: String
    // calories per 100g
    let calories: Int
    // portion in g
    let portion: Int
}
