import SwiftUI

struct InventoryView: View {
    @StateObject private var viewModel = InventoryViewModel()
    
    @State private var newItemOunces: String = ""
    @State private var newItemIncrement: String = ""
    
    @State private var selectedDate: Date = Date() // Default to today's date
    @State private var showDatePicker: Bool = false // State to control visibility of the DatePicker
    
    @FocusState private var isOuncesFocused: Bool // Focus state for ounces text field
    @FocusState private var isIncrementFocused: Bool // Focus state for increment text field
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Total ounces label with no decimal places
                Text("Total Ounces: \(Int(viewModel.totalOunces))") // Convert to integer to remove decimals
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black) // Black text color
                    .padding(.top, 20)
                
                // Toggle to show/hide DatePicker
                Toggle("Show Date Picker", isOn: $showDatePicker)
                    .padding(.horizontal)
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 1.0, green: 0.75, blue: 0.8))) // Soft pink toggle
                    .foregroundColor(.black) // Black text color
                    .padding(.top, 10)
                
                // Form to add new item with more space between elements
                HStack(spacing: 15) {
                    TextField("Ounces", text: $newItemOunces)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.pink.opacity(0.2))
                        .cornerRadius(12)
                        .shadow(radius: 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 1.0, green: 0.75, blue: 0.8), lineWidth: 1) // Soft pink accent for border
                        )
                        .focused($isOuncesFocused) // Set focus state for ounces field
                    
                    TextField("Oz/Bag", text: $newItemIncrement)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.pink.opacity(0.2))
                        .cornerRadius(12)
                        .shadow(radius: 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 1.0, green: 0.75, blue: 0.8), lineWidth: 1) // Soft pink accent for border
                        )
                        .focused($isIncrementFocused) // Set focus state for increment field
                    
                    Button(action: {
                        if let ounces = Double(newItemOunces), let increment = Double(newItemIncrement), ounces > 0, increment > 0 {
                            viewModel.addItems(ounces: ounces, increment: increment, date: selectedDate)
                            newItemOunces = ""
                            newItemIncrement = ""
                            
                            // Dismiss the keyboard after adding an item
                            hideKeyboard()
                        }
                    }) {
                        Text("Add")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 100)
                            .background(Color.pink.opacity(0.2)) // Soft pink background for the button
                            .cornerRadius(12)
                            .shadow(radius: 6)
                    }
                }
                .padding(.horizontal)
                
                // Conditionally show DatePicker based on the toggle
                if showDatePicker {
                    VStack {
                        Text("Select Date")
                            .font(.headline)
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.8)) // Soft pink color for date picker label
                            .padding(.top, 10)
                        
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: [.date] // Display only the date component
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                        .background(Color.pink.opacity(0.2))
                        .cornerRadius(12)
                        .shadow(radius: 6)
                    }
                    .padding(.horizontal)
                }
                
                // List of inventory items with improved layout
                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Added: \(item.dateAdded, formatter: itemDateFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.black) // Black text color
                                Text("\(Int(item.ounces)) oz") // Convert to integer to remove decimals
                                    .font(.headline)
                                    .foregroundColor(.black) // Black text color
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(radius: 6)
                    }
                    .onDelete(perform: viewModel.removeItem)
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .background(FloralBackgroundView()) // Adding floral background
            .onTapGesture {
                // Dismiss the keyboard when tapping outside the TextField areas
                hideKeyboard()
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
    
    // Helper function to hide the keyboard using UIApplication
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    var body: some View {
        InventoryView()
    }
}

// Custom view for floral background (simple pattern or image)
struct FloralBackgroundView: View {
    var body: some View {
        ZStack {
            Color.pink.opacity(0.1).edgesIgnoringSafeArea(.all) // Soft background color
            Image("floral-pattern") // Use your floral image here
                .resizable()
                .scaledToFill()
                .opacity(0.2)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
