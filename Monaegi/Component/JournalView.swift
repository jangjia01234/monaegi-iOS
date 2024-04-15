import SwiftUI

struct JournalView: View {
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
    
    @Binding var memos: [Memo]
    @State var memo: Memo = Memo(title: "", content: "")
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("제목", text: $memo.title)
                .font(.headline)
                .padding(.vertical, 8)
            Divider()
            TextEditor(text: $memo.content)
                .font(.subheadline)
        }
        .padding()
        .navigationBarItems(trailing:
                                Button("완료") {
            memos.append(memo)
            presentationMode.wrappedValue.dismiss()
        }
            .disabled(memo.title.isEmpty || memo.content.isEmpty)
        )
    }
}

#Preview {
    JournalView(memos: .constant([]))
}
