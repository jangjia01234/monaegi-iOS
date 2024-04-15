import SwiftUI

struct JournalListView: View {
    @State var journals: [Journal] = []
    @State var journal: Journal = Journal(title: "", content: "")
    @State private var isShowingSheet = false
    
    let todayDate : Text = Text(Date.now, format: .dateTime.year().day().month())
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(journals) { journal in
                        NavigationLink(destination: JournalDetailView(journals: $journals)) {
                            VStack(alignment: .leading) {
                                Text(journal.title)
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
                        JournalView(journals: $journals)
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
