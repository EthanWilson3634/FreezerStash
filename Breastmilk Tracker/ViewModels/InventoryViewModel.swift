import Foundation

class InventoryViewModel: ObservableObject {
    @Published var items: [InventoryItem] = [] {
        didSet {
            saveItems()
        }
    }

    // Initialize the ViewModel by loading saved items from UserDefaults
    init() {
        loadItems()
    }

    // Add items based on ounces and increment
    func addItems(ounces: Double, increment: Double, date: Date) {
        var remainingOunces = ounces
        var addedItems: [InventoryItem] = []

        // Calculate how many full increments can be added
        let fullItemsCount = Int(remainingOunces / increment)
        
        // Add full increment items
        for _ in 0..<fullItemsCount {
            addedItems.append(InventoryItem(ounces: increment, dateAdded: date))
            remainingOunces -= increment
        }
        
        // If there's a remainder and it's greater than 0, add it as the last item
        if remainingOunces > 0 {
            addedItems.append(InventoryItem(ounces: remainingOunces, dateAdded: date))
        }
        
        // Add the new items to the list
        items.append(contentsOf: addedItems)
    }

    // Remove item from the list
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    // Get total ounces
    var totalOunces: Double {
        items.reduce(0) { $0 + $1.ounces }
    }

    // Save items to UserDefaults
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "inventoryItems")
        }
    }

    // Load items from UserDefaults
    private func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "inventoryItems"),
           let decodedItems = try? JSONDecoder().decode([InventoryItem].self, from: savedItems) {
            self.items = decodedItems
        }
    }
}
