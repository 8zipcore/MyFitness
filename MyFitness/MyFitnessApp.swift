//
//  MyFitnessApp.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI
import SwiftData

@main
struct MyFitnessApp: App {
    @AppStorage("isDummyDataInserted") private var isDummyDataInserted = false
        
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Retrospect.self,
            Anaerobic.self,
            Cardio.self,
            Exercise.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
                    .task {
                        if !isDummyDataInserted {
                            await insertDummyData()
                            isDummyDataInserted = true
                        }
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
        
    func insertDummyData() async {
        do {
            let container = try ModelContainer(for: Retrospect.self, Anaerobic.self, Cardio.self, Exercise.self)
            let context = container.mainContext

            let dummyData = createRetrospects(loadDummyDataFromJSON())
            for retrospect in dummyData {
                context.insert(retrospect)
            }

            try context.save()
            print("✅ 더미 데이터 삽입 완료")
        } catch {
            print("❌ 삽입 실패: \(error)")
        }
    }
    
    func loadDummyDataFromJSON() -> [RetrospectDTO] {
        guard let url = Bundle.main.url(forResource: "DummyData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ JSON 파일을 찾을 수 없음")
            return []
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode([RetrospectDTO].self, from: data)
            return decoded
        } catch {
            print("❌ 디코딩 실패: \(error)")
            return []
        }
    }
    
    func createRetrospects(_ datas: [RetrospectDTO]) -> [Retrospect] {
        datas
            .map {
                Retrospect(
                    date: $0.date,
                    category: createCategories($0.category),
                    anaerobics: createAnarobics(
                        $0.anaerobics
                    ),
                    cardios: createCardios(
                        $0.cardios
                    ),
                    startTime: $0.startTime,
                    finishTime: $0.finishTime,
                    satisfaction: $0.satisfaction,
                    writing: $0.writing
                    ,
                    bookMark: $0.bookMark
                )
        }
    }
    
    func createAnarobics(_ datas: [AnaerobicDTO]) -> [Anaerobic] {
        datas.map { Anaerobic(name: $0.name, weight: $0.weight, count: $0.count, set: $0.set) }
    }
    
    func createCardios(_ datas: [CardioDTO]) -> [Cardio] {
        datas.map { Cardio(name: $0.name, minutes: $0.minutes) }
    }
    
    func createCategories(_ datas: [String]) -> [Category] {
        datas.map { Category(rawValue: $0) ?? .arms }
    }
}
