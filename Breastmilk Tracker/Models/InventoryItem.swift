import Foundation

struct InventoryItem: Identifiable, Codable {
    var id = UUID()  // Unique ID for each item
    var ounces: Double
    var dateAdded: Date
}
