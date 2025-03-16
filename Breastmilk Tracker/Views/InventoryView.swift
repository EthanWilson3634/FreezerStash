import SwiftUI

struct InventoryView: View {
    @StateObject private var viewModel = InventoryViewModel()
    
    @State private var newItemOunces: String = ""
    @State private var newItemIncrement: String = ""
    
    @State private var selectedDate: Date = Date() // Default to today's date
    @State private var showDatePicker: Bool = false // State to control visibility of the DatePicker
    
    // Counter for item names
    @State private var itemCounter = 1
    
    var body: some View {
        NavigationView {
            VStack {
                // Total ounces label
                Text("Total Ounces: \(viewModel.totalOunces, specifier: "%.2f")")
                    .font(.title)
                    .padding()
                
                // Toggle to show/hide DatePicker
                Toggle("Show Date Picker", isOn: $showDatePicker)
                    .padding()
                    .toggleStyle(SwitchToggleStyle(tint: .blue)) // Optional: Change color style of the toggle
                
                // Form to add new item
                HStack {
                    TextField("Ounces", text: $newItemOunces)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Increment", text: $newItemIncrement)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Add") {
                        if let ounces = Double(newItemOunces), let increment = Double(newItemIncrement), ounces > 0, increment > 0 {
                            viewModel.addItems(ounces: ounces, increment: increment, date: selectedDate)
                            newItemOunces = ""
                            newItemIncrement = ""
                            itemCounter += 1
                        }
                    }
                    .padding()
                }
                
                // Conditionally show DatePicker based on the toggle
                if showDatePicker {
                    VStack {
                        Text("Select Date (Optional)")
                            .font(.subheadline)
                            .padding(.top)
                        
                        DatePicker(
                            "Select Date",
                            selection: $selectedDate,
                            displayedComponents: [.date] // Display only the date component
                        )
                        .datePickerStyle(WheelDatePickerStyle()) // You can change the style if desired
                        .padding()
                    }
                }
                
                // List of inventory items
                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("") // Default name
                                    .font(.headline)
                                Text("Added: \(item.dateAdded, formatter: itemDateFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(item.ounces, specifier: "%.2f") oz")
                        }
                    }
                    .onDelete(perform: viewModel.removeItem)
                }
                .navigationTitle("Milk") // Change this line to "Milk"
                .navigationBarItems(trailing: EditButton())
            }
        }
    }
    
    // DateFormatter to format the date added
    private var itemDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
}

struct ContentView: View {
    var body: some View {
        InventoryView()
    }
}
