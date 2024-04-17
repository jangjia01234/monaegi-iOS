import SwiftUI

struct JournalDetailView: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject var journalState : JournalState

    var journal: JournalData
    
    @State private var title = ""
    @State private var content = ""
    
    @State private var savedTitle: String = ""
    
    @State private var isEditing: Bool = false
    
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
                            journalState.updateJournal(id: journal.id, after: JournalData(title: title, content: content, date: ""))
                            
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
                
                if isEditing == true {
                    TextEditor(text: $title)
                    Divider()
                    TextEditor(text: $content)
                } else {
                    Text(journal.title)
                    Divider()
                    Text(journal.content)
                }
            }
            Spacer()
        }
        .onTapGesture { hideKeyboardAndSave() }
        .animation(nil, value: editMode?.wrappedValue)
        .padding()
    }
    
    private func hideKeyboardAndSave() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        save()
    }
    
    private func save() {
        
        
        
//        self.journalState.addData()
//        let today = "\(Date.now)".split(separator: " ")[0]
//        
//        let journalData = JournalData(title: title, content: content, date: String(today))
//        
//        journalState.journals.append(journalData)
    }
}


#Preview {
    JournalDetailView(journal: (JournalData(title: "", content: "", date: "")))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
