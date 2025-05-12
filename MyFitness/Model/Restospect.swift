//
//  Restospect.swift
//  MyFitness
//
//  Created by 강대훈 on 5/12/25.
//

import Foundation
import SwiftData

// MARK: Retrospect (회고 데이터 스키마)
@Model
final class Restospect {
    @Attribute(.unique) var id: UUID
    var date: Date
    var category: [String]
    var anaerobics: [Anaerobic]
    var cardios: [Cardio]
    var start_time: Double
    var finish_time: Double
    var satisfaction: Double
    var writing: String // TODO: 이름이 애매함.
    var bookMark: Bool = false

    init(
        id: UUID = UUID(),
        date: Date,
        category: [String],
        anaerobics: [Anaerobic],
        cardios: [Cardio],
        start_time: Double,
        finish_time: Double,
        satisfaction: Double,
        writing: String,
        bookMark: Bool
    ) {
        self.id = id
        self.date = date
        self.category = category
        self.anaerobics = anaerobics
        self.cardios = cardios
        self.start_time = start_time
        self.finish_time = finish_time
        self.satisfaction = satisfaction
        self.writing = writing
        self.bookMark = bookMark
    }
}

// MARK: Anaerobic (무산소 데이터 스키마)
@Model
final class Anaerobic {
    @Attribute(.unique) var id: UUID
    var name: String
    var weight: Int
    var count: Int
    var set: Int

    init(id: UUID = UUID(), name: String, weight: Int, count: Int, set: Int) {
        self.id = id
        self.name = name
        self.weight = weight
        self.count = count
        self.set = set
    }
}

// MARK: Cardio (유산소 데이터 스키마)
@Model
final class Cardio {
    @Attribute(.unique) var id: UUID
    var name: String
    var minutes: Int

    init(id: UUID = UUID(), name: String, minutes: Int) {
        self.id = id
        self.name = name
        self.minutes = minutes
    }
}
