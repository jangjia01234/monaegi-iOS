import Foundation

struct JournalData: Identifiable {
    let id = UUID()
    var title: String
    var content: String
}

class JournalState: ObservableObject {
    @Published var journals: [JournalData] = []
    @Published var journal: JournalData = JournalData(title: "", content: "")
}
