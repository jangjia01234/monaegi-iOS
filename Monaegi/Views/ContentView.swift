import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
    
//    private var items: FetchedResults<Item>
    
    @EnvironmentObject var journalState : JournalState
    
    @State var journal: JournalData
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var date: String = ""
    
    @State private var isShowingSheet = false
    
    var body: some View {
        ZStack {
//            VStack {
//                CalendarView()
//                
//                Spacer() 
//                
//                JournalListView()
//                    .environmentObject(journalState)
//            }
            
            VStack {
                List {
                    ForEach(journalState.journals) { journal in
                        HStack {
                            Text(journal.title)
                            Text(journal.content)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        journalState.journals.remove(atOffsets: indexSet)
                    })
                }
                 
                HStack {
                    VStack {
                        TextField("Enter new title", text: $journal.title)
                        TextField("Enter new content", text: $journal.content)
                        
                        Button("Add Title and Content") {
                            let newJournal = JournalData(title: journal.title, content: journal.content, date: journal.date)
                            
                            journalState.journals.append(newJournal)
                             
                            journal.title = ""
                            journal.content = ""
                        }
                        
                        Button("Save Data") {
                            journalState.saveData()
                        }
                        
                        Button("Load Data") {
                            journalState.loadData()
                        }
                    }
                }
            }
        }
        .background(.black)
        .onAppear(perform: journalState.loadData)
    }

    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            // MARK: 에러 핸들링 코드
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

func didDismiss() {
    // MARK: dissmiss 액션 코드
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

#Preview {
    ContentView(journal: (JournalData(title: "", content: "", date: "")))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(JournalState())
}
