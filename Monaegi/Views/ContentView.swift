import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var journalState : JournalState
    @State private var isShowingSheet = false
    
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
    }
}


#Preview {
    ContentView()
        .environmentObject(JournalState())
}

