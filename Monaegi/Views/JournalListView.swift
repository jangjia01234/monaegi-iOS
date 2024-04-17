import SwiftUI

struct JournalListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var journalState : JournalState
    
    @State private var isShowingAddSheet = false
    @State private var isShowingViewSheet = false
    
    let todayDate : String = String("\(Date.now)".split(separator: " ")[0])
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(journalState.journals.enumerated()), id: \.1) { idx, journal in
                        Button(action: {
                            isShowingViewSheet = true
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(journal.date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 4)
                                
                                Text(journal.title)
                                    .font(.headline)
                                
                                Text(journal.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                
                            }
                        })
                        .sheet(isPresented: $isShowingViewSheet, onDismiss: didDismiss) {
                        
                            JournalDetailView(journal: journal)
                                .environmentObject(journalState)
                                .navigationTitle(todayDate)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button {
                                            isShowingViewSheet.toggle()
                                        } label: {
                                            Text("취소")
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                            
                        }
                    }
                    .onDelete(perform: { indexSet in
                        journalState.journals.remove(atOffsets: indexSet)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    isShowingAddSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundColor(Color("AccentColor"))
                        .padding(.bottom, 20)
                }
                .sheet(isPresented: $isShowingAddSheet,
                       onDismiss: didDismiss) {
                    NavigationStack {
                        JournalView()
                            .navigationTitle(todayDate)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar(content: {
                                ToolbarItemGroup(placement: .topBarLeading) {
                                    Button {
                                        isShowingAddSheet.toggle()
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

#Preview {
    JournalListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(JournalState())
}
