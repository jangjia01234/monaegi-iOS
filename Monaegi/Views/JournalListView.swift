import SwiftUI

struct JournalListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var journalState : JournalState
    
    @State var journal: JournalData
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var date: String = ""
    
    @State private var isShowingAddSheet = false
    @State private var isShowingViewSheet = false
    
    let todayDate : String = String("\(Date.now)".split(separator: " ")[0])
    
    var body: some View {
        NavigationStack {
            VStack {
//                Button {
//                    print("journalState.selectedDate", journalState.selectedDate)
//                    print("journalState.journals.first!.date", journalState.journals.first!.date)
//                } label: {
//                    Text("Test")
//                }
                
                if journalState.isShowingList {
                    List {
                        ForEach(Array(journalState.journals.enumerated()), id: \.1) { idx, journal in
                            if String(journalState.selectedDate) == String(journalState.journals[idx].date) {
                                Button(action: {
                                    isShowingViewSheet = true
                                    print("journalState.journals[idx]", journalState.journals[idx])
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
                                .sheet(isPresented: $isShowingViewSheet) {
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
                        }
                        .onDelete(perform: { indexSet in
                            journalState.journals.remove(atOffsets: indexSet)
                            journalState.saveData()
                        })
                        .listRowBackground(Color("darkGray"))
                    }
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
                .sheet(isPresented: $isShowingAddSheet) {
                    NavigationStack {
                        JournalView()
                            .navigationTitle(
                                journalState.selectedDate
                            )
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
        .onAppear(perform: journalState.loadData)
    }
}

#Preview {
    JournalListView(journal: (JournalData(title: "", content: "", date: "")))
        .environmentObject(JournalState())
}
