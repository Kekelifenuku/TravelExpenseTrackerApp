import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Binding var currentTab: String

    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)
    ], animation: .snappy) private var allExpenses: [Expense]

    @Environment(\.modelContext) private var context
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var originalGroupedExpenses: [GroupedExpenses] = []
    @State private var addExpense: Bool = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach($groupedExpenses) { $group in
                        Section(group.groupTitle) {
                            ForEach(group.expenses) { expense in
                                ExpenseCardView(expense: expense)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            context.delete(expense)
                                            withAnimation {
                                                group.expenses.removeAll { $0.id == expense.id }
                                                if group.expenses.isEmpty {
                                                    groupedExpenses.removeAll { $0.id == group.id }
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Expenses")
                .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: Text("Search"))
                .overlay {
                    if allExpenses.isEmpty || groupedExpenses.isEmpty {
                        ContentUnavailableView {
                            Label("No Expenses", systemImage: "tray.fill")
                        }
                    }
                }

                // Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            addExpense.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                        .accessibilityLabel("Add Expense")
                    }
                }
            }
        }
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
                .interactiveDismissDisabled()
        }
        .onChange(of: searchText, initial: false) { _, newValue in
            if !newValue.isEmpty {
                filterExpenses(newValue)
            } else {
                groupedExpenses = originalGroupedExpenses
            }
        }
        .onChange(of: allExpenses, initial: true) { oldValue, newValue in
            if newValue.count > oldValue.count || groupedExpenses.isEmpty || currentTab == "Categories" {
                createGroupedExpenses(newValue)
            }
        }
    }

    func filterExpenses(_ text: String) {
        Task.detached(priority: .high) {
            let query = text.lowercased()
            let filteredExpenses = originalGroupedExpenses.compactMap { group -> GroupedExpenses? in
                let expenses = group.expenses.filter { $0.title.lowercased().contains(query) }
                return expenses.isEmpty ? nil : GroupedExpenses(date: group.date, expenses: expenses)
            }

            await MainActor.run {
                groupedExpenses = filteredExpenses
            }
        }
    }

    func createGroupedExpenses(_ expenses: [Expense]) {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                Calendar.current.dateComponents([.day, .month, .year], from: expense.date)
            }

            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .now
                let date2 = calendar.date(from: $1.key) ?? .now
                return date1 > date2
            }

            await MainActor.run {
                groupedExpenses = sortedDict.compactMap { key, value in
                    let date = Calendar.current.date(from: key) ?? .now
                    return GroupedExpenses(date: date, expenses: value)
                }
                originalGroupedExpenses = groupedExpenses
            }
        }
    }
}

#Preview {
    ContentView()
}
