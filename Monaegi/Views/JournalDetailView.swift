import SwiftUI

struct JournalDetailView: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject var journalState : JournalState
    
    @State var journal: JournalData
    
//    @State private var title = ""
//    @State private var content = ""
    
    @State private var savedTitle: String = ""
    
    @State private var isEditing: Bool = false
    
    @State private var todayDate : String = String("\(Date.now)".split(separator: " ")[0])
    
//    init(title: String, content: String, date: String) {
//        self.journal = JournalData(title: title, content: content, date: date)
//        
//        self.title = journal.title
//        self.content = journal.content
//    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(journal.date)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if isEditing {
                            journalState.updateJournal(id: journal.id, after: JournalData(title: journal.title, content: journal.content, date: todayDate))
                        } else {
                            print("button is working in non-editing environment")
                        }
                        
                        isEditing.toggle()
                        
                    }, label: {
                        Text(isEditing ? "완료" : "수정")
                            .fontWeight(.semibold)
                    })
                    .padding(.bottom, 10)
                }
                
                if isEditing {
                    TextField("", text: $journal.title)
                    Divider()
                    TextField("", text: $journal.content)
                } else {
                    Text(journal.title)
                    Divider()
                    Text(journal.content)
                }
            }
            Spacer()
        }
//        .onTapGesture { hideKeyboardAndSave() }
        .animation(nil, value: editMode?.wrappedValue)
        .padding()
    }
    
//    private func hideKeyboardAndSave() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        
//        journalState.updateJournal(id: journal.id, after: JournalData(title: journal.title, content: journal.content, date: todayDate))
//    }
}


#Preview {
    JournalDetailView(journal: (JournalData(title: "", content: "", date: "")))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
