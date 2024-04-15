import Foundation

struct Journal: Identifiable {
    let id = UUID()
    var title: String
    var content: String
}
