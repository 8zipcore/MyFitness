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
final class Retrospect {
    @Attribute(.unique) var id: UUID
    var date: Date
    var category: [Category] // MARK: Category로 변경

    @Relationship(deleteRule: .cascade, inverse: \Anaerobic.retrospect)
    var anaerobics: [Anaerobic]

    @Relationship(deleteRule: .cascade, inverse: \Anaerobic.retrospect)
    var cardios: [Cardio]

    var startTime: Date // MARK: 변경
    var finishTime: Date // MARK: 변경
    var satisfaction: Double
    var writing: String // TODO: 이름이 애매함.
    var bookMark: Bool = false

    init(
        id: UUID = UUID(),
        date: Date,
        category: [Category],
        anaerobics: [Anaerobic],
        cardios: [Cardio],
        startTime: Date,
        finishTime: Date,
        satisfaction: Double,
        writing: String,
        bookMark: Bool
    ) {
        self.id = id
        self.date = date
        self.category = category
        self.anaerobics = anaerobics
        self.cardios = cardios
        self.startTime = startTime
        self.finishTime = finishTime
        self.satisfaction = satisfaction
        self.writing = writing
        self.bookMark = bookMark
    }
}

// MARK: Anaerobic (무산소 데이터 스키마)
@Model
final class Anaerobic {
    @Attribute(.unique) var id: UUID

    var retrospect: Retrospect?
    var exercise: Exercise
    var weight: Int
    var count: Int
    var set: Int

    init(id: UUID = UUID(), exercise: Exercise, weight: Int, count: Int, set: Int) {
        self.id = id
        self.exercise = exercise
        self.weight = weight
        self.count = count
        self.set = set
    }
}

// MARK: Cardio (유산소 데이터 스키마)
@Model
final class Cardio {
    @Attribute(.unique) var id: UUID

    var retrospect: Retrospect?
    var exercise: Exercise
    var minutes: Int

    init(id: UUID = UUID(), exercise: Exercise, minutes: Int) {
        self.id = id
        self.exercise = exercise
        self.minutes = minutes
    }
}

// MARK: 세부 운동 이름
// MARK: 기본적인 세부 운동 데이터를 주입해줘야 함.
@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
