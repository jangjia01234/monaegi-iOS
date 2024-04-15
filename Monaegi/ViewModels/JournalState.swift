import Foundation

class JournalState: ObservableObject {
    @Published var journals: [JournalData] = []
    @Published var journal: JournalData = JournalData(title: "", content: "")
}
