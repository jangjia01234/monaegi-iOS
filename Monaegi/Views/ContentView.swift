import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var journalState : JournalState
    
    var body: some View {
        ZStack {
            VStack {
                CalendarView()
                
                Spacer()
                
                JournalListView(journal: (JournalData(title: "", content: "", date: "")))
                    .environmentObject(journalState)
            }
        }
        .background(.black)
        
        // git 연습중입니다.
    }
}


#Preview {
    ContentView()
        .environmentObject(JournalState())
}

