import Foundation

class JournalState: ObservableObject {
    @Published var journals: [JournalData] = []
    
    
//    func addData() {
//        self.journals.append(JournalData(title: "1", content: "2", date: "3"))
//    }
    
    func updateJournal(id: UUID, after: JournalData) {
        guard let index = journals.firstIndex(where: { $0.id == id }) else { return }
        journals[index] = after
    }
}
