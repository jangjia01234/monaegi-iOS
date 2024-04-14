import SwiftUI

struct JournalView: View {
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .padding()
                .foregroundColor(Color.black)
                .font(.custom("원하는글꼴", size: 14))
                .lineSpacing(5)
                .frame(width: .infinity, height: 300)
                // ❌ FIX: 테스트용이므로 삭제 예정
                .border(Color("AccentColor"), width: 2)
                .onChange(of: text) { oldValue, newValue in
                    print("수정된 텍스트 = \(text) ")
                }
            
            Spacer()
        }
    }
}

#Preview {
    JournalView()
}
