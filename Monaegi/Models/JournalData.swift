import Foundation

struct JournalData: Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var date: String
}
