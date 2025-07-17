
import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    // View Properties
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?

    // Categories
    @Query(animation: .snappy) private var allCategories: [Category]

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Title").font(.headline)) {
                    TextField("e.g. Magic Keyboard", text: $title)
                        .textContentType(.name)
                }

                Section(header: Text("Description").font(.headline)) {
                    TextField("e.g. Bought a keyboard at the Apple Store", text: $subTitle)
                        .textContentType(.none)
                }

                Section(header: Text("Amount Spent").font(.headline)) {
                    HStack(spacing: 4) {
                        Text("$")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        TextField("0.00", value: $amount, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.leading)
                    }
                }

                Section(header: Text("Date").font(.headline)) {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }

                if !allCategories.isEmpty {
                    Section(header: Text("Category").font(.headline)) {
                        Menu {
                            ForEach(allCategories) { cat in
                                Button(cat.categoryName) {
                                    category = cat
                                }
                            }

                            Divider()

                            Button("None") {
                                category = nil
                            }
                        } label: {
                            HStack {
                                Text(category?.categoryName ?? "Select Category")
                                    .foregroundColor(category == nil ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", action: addExpense)
                        .disabled(isAddButtonDisabled)
                }
            }
        }
    }

    // Add Button Condition
    var isAddButtonDisabled: Bool {
        title.isEmpty || subTitle.isEmpty || amount == .zero
    }

    // Save Expense to SwiftData
    func addExpense() {
        let expense = Expense(
            title: title,
            subTitle: subTitle,
            amount: amount,
            date: date,
            category: category
        )
        context.insert(expense)
        dismiss()
    }

    // Currency Formatter
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    AddExpenseView()
}
