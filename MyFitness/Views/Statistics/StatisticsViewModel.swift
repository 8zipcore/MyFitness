import SwiftUI

final class StatisticsViewModel: ObservableObject {
    @Published var periodTimes: [PeriodTime] = []
    @Published var anaerobicCounts: [ExerciseCount] = []
    @Published var cardioCounts: [ExerciseCount] = []
    @Published var anaerobicTotalCount: Int = 0
    @Published var cardioTotalCount: Int = 0
    @Published var anaerobicMaxCount: Int = 0
    @Published var cardioMaxCount: Int = 0

    func setData(retrospects: [Retrospect]) {
        setPeriodTime(retrospects: retrospects)
        setCardioCount(retrospects: retrospects)
        setAnaerobicCount(retrospects: retrospects)
        setCardioTotalCount(retrospects: retrospects)
        setAnaerobicTotalCount(retrospects: retrospects)

        anaerobicMaxCount = anaerobicCounts.max { $0.count < $1.count }?.count ?? 0
        cardioMaxCount = cardioCounts.max { $0.count < $1.count }?.count ?? 0
    }

    func getCategoryCount(retrospects: [Retrospect], category: Category) -> Int {
        return retrospects.flatMap { $0.category.filter { $0 == category } }.count
    }

    private func setPeriodTime(retrospects: [Retrospect]) {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: retrospects) { retrospect -> Period in
            let hour = calendar.component(.hour, from: retrospect.startTime)
            switch hour {
            case 0..<8:
                return .evening
            case 8..<16:
                return .morning
            default:
                return .dayTime
            }
        }

        let periodTimes = Period.allCases.map {
            PeriodTime(period: $0, count: grouped[$0]?.count ?? 0)
        }

        self.periodTimes = periodTimes
    }

    private func setAnaerobicTotalCount(retrospects: [Retrospect]) {
        self.anaerobicTotalCount = retrospects.map { $0.anaerobics.map { $0.name }.count }.count
    }

    private func setCardioTotalCount(retrospects: [Retrospect]) {
        self.cardioTotalCount = retrospects.map { $0.cardios.map { $0.name }.count }.count
    }

    private func setAnaerobicCount(retrospects: [Retrospect]) {
        var anaerobicCountList: [ExerciseCount] = []
        retrospects.flatMap { $0.anaerobics }.map { $0.name }.reduce(into: [:]) { results, name in
            results[name, default: 0] += 1
        }
        .sorted {
            $0.value > $1.value
        }
        .forEach {
            anaerobicCountList.append(ExerciseCount(name: $0.key, count: $0.value))
        }

        self.anaerobicCounts = anaerobicCountList
    }

    private func setCardioCount(retrospects: [Retrospect]) {
        var cardioCountList: [ExerciseCount] = []
        retrospects.flatMap { $0.cardios }.map { $0.name }.reduce(into: [:]) { results, name in
            results[name, default: 0] += 1
        }
        .sorted {
            $0.value > $1.value
        }
        .forEach {
            cardioCountList.append(ExerciseCount(name: $0.key, count: $0.value))
        }

        self.cardioCounts = anaerobicCounts
    }
}

