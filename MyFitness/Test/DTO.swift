//
//  DTO.swift
//  MyFitness
//
//  Created by 홍승아 on 5/15/25.
//

import Foundation

struct RetrospectDTO: Codable {
    var id: UUID
    var date: Date
    var category: [String]
    var anaerobics: [AnaerobicDTO]
    var cardios: [CardioDTO]
    var startTime: Date
    var finishTime: Date
    var satisfaction: Double
    var writing: String
    var bookMark: Bool
}

struct AnaerobicDTO: Codable {
    var id: UUID
    var name: String
    var weight: Int
    var count: Int
    var set: Int
}

struct CardioDTO: Codable {
    var id: UUID
    var name: String
    var minutes: Int
}
