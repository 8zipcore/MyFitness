struct PeriodTime {
    var period: Period
    var count: Int
}

enum Period: String, CaseIterable {
    case morning = "오전"
    case dayTime = "오후"
    case evening = "새벽"

    var timeRange: String {
        switch self {
        case .dayTime:
            return "16 ~ 24시 이전"
        case .morning:
            return "08 ~ 16시 이전"
        case .evening:
            return "00 ~ 08시 이전"
        }
    }
}
