import SwiftUI

struct JournalDetailView: View {
    @Environment(\.editMode) private var editMode
    
    var journal: JournalData
    
    @State private var title = ""
    @State private var content = ""
    
    @State private var savedTitle: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(journal.date)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                if editMode?.wrappedValue.isEditing == true {
                    TextField("", text: .constant(self.journal.title))
                    Divider()
                    TextField("", text: .constant(self.journal.content))
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
        .toolbar {
            EditButton()
        }
        .padding()
    }
    
    private func hideKeyboardAndSave() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        save()
    }
    
    private func save() {
        savedTitle = title
    }
}


#Preview {
    JournalDetailView(journal: (JournalData(title: "", content: "", date: "")))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
