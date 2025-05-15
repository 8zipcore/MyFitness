/// 통계에서 주, 월 단위를 구분하기 위한 객체입니다.
enum WeekOrMonth: String, CaseIterable, Identifiable {
    case week = "주"
    case month = "월"

    var id: String { self.rawValue }
}
