import SwiftUI

struct JournalDetailView: View {
    @EnvironmentObject var journalData : JournalState
    
    var body: some View {
        VStack {
            TextEditor(text: $journalData.journal.title)
                .frame(height: 40)
            
            Divider()
            
            TextEditor(text: $journalData.journal.content)
                .font(.subheadline)
        }
        .padding()
    }
}
