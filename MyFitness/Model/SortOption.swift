/// 정렬에 쓰이는 요소들 객체입니다.
enum SortOption: String, CaseIterable, Identifiable {
    case dateDesc = "최신 순"
    case dateAsc = "오래된 순"
    case satisfactionDesc = "만족도 높은 순"
    case satisfactionAsc = "만족도 낮은 순"
    case weightDesc = "무게 높은 순"
    case weightAsc = "무게 낮은 순"
    var id: String { rawValue }
}
