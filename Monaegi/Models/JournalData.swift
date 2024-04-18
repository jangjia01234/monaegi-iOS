import Foundation

struct JournalData: Codable, Identifiable, Hashable {
    let id: UUID = UUID()
    var title: String
    var content: String
    var date: String
}
