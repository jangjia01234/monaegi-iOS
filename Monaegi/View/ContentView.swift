import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var isShowingSheet = false

    var body: some View {
//        NavigationView {
//            ZStack {
//                List {
//                    ForEach(items) { item in
//                        NavigationLink {
//                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                        } label: {
//                            Text(item.timestamp!, formatter: itemFormatter)
//                        }
//                    }
//                    .onDelete(perform: deleteItems)
//                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    }
//                    ToolbarItem {
//                        Button(action: addItem) {
//                            Label("Add Item", systemImage: "plus")
//                        }
//                    }
//                }
//                
//                Button(action: addItem) {
//                    Label("", systemImage: "plus.circle.fill")
//                }
//                .font(.system(size: 50))
//                .foregroundColor(Color("AccentColor"))
//                // 🚨 FIX: 다른 레이아웃 배치 방식으로 수정 필요
//                .padding(.top, 600)
//            }
//        }
        
        VStack {
            CalendarView()
                .padding(.vertical, 50)
            
            Spacer()
            
//            Button(action: addItem) {
//                Label("", systemImage: "plus.circle.fill")
//            }
//            .font(.system(size: 60))
//            .foregroundColor(Color("AccentColor"))
//            .padding(.bottom, 50)
            
             
            // MARK: sheet 테스트
            Button(action: {
                        isShowingSheet.toggle()
                        //  addItem()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundColor(Color("AccentColor"))
                            .padding(.bottom, 50)
                    }
                    .sheet(isPresented: $isShowingSheet,
                           onDismiss: didDismiss) {
                        VStack {
                            JournalView()
                            
                            Button("Dismiss",
                                   action: { isShowingSheet.toggle() })
                        }
                    }
        }
        .background(.black)
    }
    
    func didDismiss() {
        // MARK: dissmiss 액션 코드
        }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            // MARK: 에러 핸들링 코드
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
