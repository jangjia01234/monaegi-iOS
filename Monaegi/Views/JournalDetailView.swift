import SwiftUI

struct JournalDetailView: View {
    var journal: JournalData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(journal.date)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            Text(journal.title)
                .font(.title2)
            
            Divider()
            
            Text(journal.content)
                .font(.title3)
            
            Spacer()
            
            //            TextEditor(text: journal.title)
            //                .frame(height: 40)
            //
            //            Divider()
            //
            //            TextEditor(text: journal.content)
            //                .font(.subheadline)
        }
        .padding()
    }
}
