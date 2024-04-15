import SwiftUI

struct JournalListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var journalData : JournalState
    
    @State private var isShowingSheet = false
    
    let todayDate : Text = Text(Date.now, format: .dateTime.year().day().month())
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(journalData.journals) { journal in
                        NavigationLink(destination: JournalDetailView()) {
                            VStack(alignment: .leading) {
                                Text(journalData.journal.title)
                                    .font(.headline)
                                Text(journalData.journal.content)
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
