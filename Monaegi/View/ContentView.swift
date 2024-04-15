import SwiftUI
import CoreData

struct Memo: Identifiable {
    let id = UUID()
    var title: String
    var content: String
}

struct MemoListView: View {
    @State var memos: [Memo] = []
    @State private var isShowingSheet = false
    
    let todayDate : Text = Text(Date.now, format: .dateTime.year().day().month())
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(memos) { memo in
                        VStack(alignment: .leading) {
                            Text(memo.title)
                                .font(.headline)
                            Text(memo.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
//                        .listRowBackground(Color.gray)
                        
                        .sheet(isPresented: $isShowingSheet,
                               onDismiss: didDismiss) {
                            MemoDetailView(memo: memo)
                                .presentationDetents([.large])
                        }
                        
//                        NavigationLink(destination: MemoDetailView(memo: memo)) {
//                            VStack(alignment: .leading) {
//                                Text(memo.title)
//                                    .font(.headline)
//                                Text(memo.content)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("일기 리스트")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    isShowingSheet.toggle()
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
                        JournalView(memos: $memos)
                            .navigationTitle(todayDate)
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
                            })
                    }
                    .presentationDetents([.large])
                }
            }
            .scrollContentBackground(.hidden)
            .background(.black)
        }
    }
}

struct MemoDetailView: View {
    @State var memo: Memo
    
    var body: some View {
        VStack {
            TextEditor(text: $memo.title)
                .frame(height: 50)
            
            Divider()
            
            TextEditor(text: $memo.content)
                .font(.subheadline)
        }
        .padding()
    }
}

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
            
            // Memo test
            MemoListView()
            
            
            // ✅ MARK: sheet 테스트
//                        Button(action: {
//                            isShowingSheet.toggle()
//                            //  addItem()
//                        }) {
//                            Image(systemName: "plus.circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 50)
//                                .foregroundColor(Color("AccentColor"))
//                                .padding(.bottom, 20)
//                        }
//                        .sheet(isPresented: $isShowingSheet,
//                               onDismiss: didDismiss) {
//                            NavigationStack {
//                                JournalView()
//                                    // ❌ FIX: 실제 날짜로 변경 예정
//                                    .navigationTitle("24.04.15")
//                                    .navigationBarTitleDisplayMode(.inline)
//                                    .toolbar(content: {
//                                        ToolbarItemGroup(placement: .topBarLeading) {
//                                            Button {
//                                                isShowingSheet.toggle()
//                                            } label: {
//                                                Text("취소")
//                                                    .fontWeight(.semibold)
//                                            }
//                                        }
//            
//                                        ToolbarItemGroup(placement: .topBarTrailing) {
//                                            Button {
//                                                isShowingSheet.toggle()
//                                            } label: {
//                                                Text("완료")
//                                                    .fontWeight(.semibold)
//                                            }
//                                        }
//                                    })
//            
//                            }
//                            .presentationDetents([.large])
//                        }
        }
        .background(.black)
    }
    
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

func didDismiss() {
    // MARK: dissmiss 액션 코드
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
