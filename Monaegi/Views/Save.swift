import SwiftUI

struct Save: View {
    @State private var people = [Person]()
    @State private var newName: String = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(people) { person in
                    Text(person.name)
                }
                .onDelete(perform: { indexSet in
                    people.remove(atOffsets: indexSet)
                })
            }
            
            
            TextField("Enter new name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Add Name") {
                let newPerson = Person(name: newName)
                people.append(newPerson)
                newName = ""
            }
            
            Button("Save Names") {
                saveNames()
            }
            
            Button("Load Names") {
                loadNames()
            }
        }
        .onAppear(perform: loadNames)
    }
    
    func saveNames() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("names.json")
        if let data = try? JSONEncoder().encode(people) {
            try? data.write(to: fileURL)
        }
    }
    
    func loadNames() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("names.json")
        if let data = try? Data(contentsOf: fileURL) {
            if let decoded = try? JSONDecoder().decode([Person].self, from: data) {
                self.people = decoded
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

//{
//id:dfgdfgdfg234
//name:leeo
//}

struct Person: Codable, Identifiable {
    var id = UUID()
    let name: String
}


#Preview {
    Save()
}
