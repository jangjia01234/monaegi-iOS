import SwiftUI

struct JournalDetailView: View {
    var journal: JournalData
    
    @State private var title = ""
    @State private var content = ""
    
    @Environment(\.editMode) private var editMode
    //    @State private var disableTextEditor = true
    
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
                
                //                TextEditor(text: .constant(self.journal.title))
                //                    .frame(height: 40)
                //                    .disabled(disableTextEditor)
                //                    .onChange(of: editMode?.wrappedValue) { _, newValue in
                //                        if (newValue != nil) && (newValue!.isEditing) {
                //                            disableTextEditor = false
                //                        } else {
                //                            disableTextEditor = true
                //                        }
                //                    }
                //
                //                Divider()
                //
                //                TextEditor(text: .constant(self.journal.content))
                //                    .font(.title3)
            }
            Spacer()
        }
        .animation(nil, value: editMode?.wrappedValue)
        .toolbar {
            EditButton()
        }
        .padding()
    }
}


#Preview {
    JournalDetailView(journal: (JournalData(title: "", content: "", date: "")))
}
