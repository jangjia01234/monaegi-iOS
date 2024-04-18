import Foundation

class JournalState: ObservableObject {
    @Published var journals: [JournalData] = []
    
    func updateJournal(id: UUID, after: JournalData) {
        guard let index = journals.firstIndex(where: { $0.id == id }) else { return }
        journals[index] = after
    }
}
