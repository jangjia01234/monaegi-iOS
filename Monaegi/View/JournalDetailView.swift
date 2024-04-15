import SwiftUI

struct JournalDetailView: View {
    @Binding var journals: [Journal]
    @State var journal: Journal = Journal(title: "", content: "")
    
    var body: some View {
        VStack {
            TextEditor(text: $journal.title)
                .frame(height: 50)
            
            Divider()
            
            TextEditor(text: $journal.content)
                .font(.subheadline)
        }
        .padding()
    }
}
