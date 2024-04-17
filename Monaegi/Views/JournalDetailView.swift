import SwiftUI

struct JournalDetailView: View {
    var journal: JournalData
    
    @State private var isEditing: Bool = false
    
    @State private var title = ""
    @State private var content = ""
    
    @Environment(\.editMode) private var editMode
    @State private var disableTextEditor = true
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    isEditing.toggle()
                }, label: {
                    Text("수정")
                        .fontWeight(.semibold)
                })
                .padding(.bottom, 10)
            }
            
            VStack(alignment: .leading) {
                Text(journal.date)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                TextEditor(text: .constant(self.journal.title))
                    .frame(height: 40)
                    .disabled(disableTextEditor)
                    .onChange(of: editMode?.wrappedValue) { _, newValue in
                        if (newValue != nil) && (newValue!.isEditing) {
                            disableTextEditor = false
                        } else {
                            disableTextEditor = true
                        }
                    }
                
                Divider()
                
                TextEditor(text: .constant(self.journal.content))
                    .font(.title3)
            }
            
//            if !isEditing {
//                VStack(alignment: .leading) {
//                    Text(journal.date)
//                        .foregroundColor(.gray)
//                        .padding(.bottom, 10)
//                    
//                    TextEditor(text: .constant(self.journal.title))
//                        .frame(height: 40)
//                    
//                    Divider()
//                    
//                    TextEditor(text: .constant(self.journal.content))
//                        .font(.title3)
//                }
//            } else {
//                    TextEditor(text: $title)
//                        .frame(height: 40)
//                    
//                    Divider()
//                    
//                    TextEditor(text: $content)
//                        .font(.subheadline)
//            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    JournalDetailView(journal: (JournalData(title: "", content: "", date: "")))
}
