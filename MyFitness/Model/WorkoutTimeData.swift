import Foundation

/// 주단위로 운동한 시간을 기록하는 객체입니다.
struct WorkoutTimeData: Identifiable {
    var id = UUID()
    var week: String
    var time: Int
}
