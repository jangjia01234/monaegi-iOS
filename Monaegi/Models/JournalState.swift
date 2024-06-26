import Foundation

class JournalState: ObservableObject {
    @Published var journals: [JournalData] = []
    @Published var isShowingList: Bool = false
    @Published var selectedDate: String = ""
    
    func updateJournal(id: UUID, after: JournalData) {
        guard let index = journals.firstIndex(where: { $0.id == id }) else { return }
        journals[index] = after
    }
    
    func saveData() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("journals.json")
        
        if let data = try? JSONEncoder().encode(journals) {
            try? data.write(to: fileURL)
        } else { print("Can't save data") }
    }

    func loadData() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("journals.json")
        if let data = try? Data(contentsOf: fileURL) {
            if let decoded = try? JSONDecoder().decode([JournalData].self, from: data) {
                self.journals = decoded
            }
        } else { print("Can't load data") }
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
