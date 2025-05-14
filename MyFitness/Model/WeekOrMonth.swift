enum WeekOrMonth: String, CaseIterable, Identifiable {
    case week = "주"
    case month = "월"

    var id: String { self.rawValue }
}
