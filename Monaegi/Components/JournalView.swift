import SwiftUI

struct JournalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var journalState : JournalState
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var date: String = ""
    
    let todayDate : Text = Text(Date.now, format: .dateTime.year().day().month())
    
    var body: some View {
        VStack {
            TextField("제목", text: $title)
                .font(.headline)
                .padding(.vertical, 8)
            
            Divider()
            
            TextEditor(text: $content)
                .font(.subheadline)
                .overlay {
                    VStack {
                        HStack {
                            Text(content.isEmpty ? "글을 작성해보세요." : "")
                                .allowsHitTesting(false)
                                .foregroundColor(.gray)
                                .padding(.leading, 5)
                                .padding(.top, 6)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
        }
        .padding()
        .navigationBarItems(trailing:
                                Button("완료") {
            let today = "\(Date.now)".split(separator: " ")[0]
            
            let journalData = JournalData(title: title, content: content, date: String(today))
            
            journalState.journals.append(journalData)
            
            presentationMode.wrappedValue.dismiss()
        }
            .disabled(title.isEmpty || content.isEmpty)
        )
    }
    
    //    @State private var text: String = ""
    //
    //    var body: some View {
    //        VStack {
    //            TextEditor(text: $text)
    //                .padding()
    //                .foregroundColor(Color.black)
    //                .font(.custom("원하는글꼴", size: 14))
    //                .lineSpacing(5)
    //                .frame(width: .infinity, height: 300)
    //                // ❌ FIX: 테스트용이므로 삭제 예정
    //                .border(Color("AccentColor"), width: 2)
    //                .onChange(of: text) { oldValue, newValue in
    //                    print("수정된 텍스트 = \(text) ")
    //                }
    //
    //            Spacer()
    //        }
    //    }
}

#Preview {
    JournalView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(JournalState())
}
