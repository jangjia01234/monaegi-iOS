import SwiftUI

struct JournalListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var journalState : JournalState
    
    @State private var isShowingSheet = false
    
    let todayDate : String = String("\(Date.now)".split(separator: " ")[0])
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(journalState.journals) { journal in
                        NavigationLink(destination: JournalDetailView(journal: journal)) {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    Text(journal.date)
                                    Text(journal.title)
                                }
                                .font(.headline)
                                
                                Text(journal.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
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
                        JournalView()
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

#Preview {
    JournalListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(JournalState())
}
