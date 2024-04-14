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
        VStack {
            CalendarView()
                .padding(.bottom, 20)
            
            Spacer()
            
            // ✅ MARK: sheet 테스트
            Button(action: {
                isShowingSheet.toggle()
                //  addItem()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.bottom, 20)
            }
            .sheet(isPresented: $isShowingSheet,
                   onDismiss: didDismiss) {
                NavigationStack {
                    JournalView()
                        // ❌ FIX: 실제 날짜로 변경 예정
                        .navigationTitle("24.04.15")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                            ToolbarItemGroup(placement: .topBarLeading) {
                                Button {
                                    isShowingSheet.toggle()
                                } label: {
                                    Text("취소")
                                        .fontWeight(.semibold)
                                }
                            }
                            
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                Button {
                                    isShowingSheet.toggle()
                                } label: {
                                    Text("완료")
                                        .fontWeight(.semibold)
                                }
                            }
                        })
                    
                }
                .presentationDetents([.large])
            }
            
        }
        .background(.black)
    }
    
    func didDismiss() {
        // MARK: dissmiss 액션 코드
    }
    //
    //        private func addItem() {
    //            withAnimation {
    //                let newItem = Item(context: viewContext)
    //                newItem.timestamp = Date()
    //
    //                // MARK: 에러 핸들링 코드
    //                do {
    //                    try viewContext.save()
    //                } catch {
    //                    let nsError = error as NSError
    //                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //                }
    //            }
    //        }
    //
    //        private func deleteItems(offsets: IndexSet) {
    //            withAnimation {
    //                offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //                do {
    //                    try viewContext.save()
    //                } catch {
    //                    let nsError = error as NSError
    //                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //                }
    //            }
    //        }
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
