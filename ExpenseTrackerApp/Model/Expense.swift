import SwiftUI
import SwiftData

@Model
class Expense {
    // MARK: - Properties
    var title: String
    var subTitle: String
    var amount: Double
    var date: Date
    var category: Category?

    // MARK: - Initializer
    init(title: String, subTitle: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.category = category
    }

    // MARK: - Computed Properties
    @Transient
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

