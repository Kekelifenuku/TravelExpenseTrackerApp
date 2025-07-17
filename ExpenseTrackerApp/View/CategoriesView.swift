import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context

    // View Properties
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    @State private var deleteRequest: Bool = false
    @State private var requestedCategory: Category?

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(sortedCategories) { category in
                        DisclosureGroup {
                            if let expenses = category.expenses, !expenses.isEmpty {
                                ForEach(expenses) { expense in
                                    ExpenseCardView(expense: expense, displayTag: false)
                                }
                            } else {
                                ContentUnavailableView {
                                    Label("No Expenses", systemImage: "tray.fill")
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        } label: {
                            Text(category.categoryName)
                                .font(.headline)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteRequest = true
                                requestedCategory = category
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("Categories")
                .overlay {
                    if allCategories.isEmpty {
                        ContentUnavailableView {
                            Label("No Categories", systemImage: "tray.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                /// Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            addCategory = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                        }
                        .padding()
                        .accessibilityLabel("Add Category")
                    }
                }
            }
        }
        .sheet(isPresented: $addCategory) {
            categoryName = ""
        } content: {
            NavigationStack {
                Form {
                    Section("Category Name") {
                        TextField("e.g. Travel", text: $categoryName)
                            .textInputAutocapitalization(.words)
                    }
                }
                .navigationTitle("New Category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            addCategory = false
                        }
                        .tint(.red)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            let newCategory = Category(categoryName: categoryName)
                            context.insert(newCategory)
                            addCategory = false
                        }
                        .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .presentationDetents([.height(180)])
            .presentationCornerRadius(16)
            .interactiveDismissDisabled()
        }
        .alert("Deleting this category will remove all related expenses. This cannot be undone.", isPresented: $deleteRequest) {
            Button("Delete", role: .destructive) {
                if let requestedCategory {
                    context.delete(requestedCategory)
                    self.requestedCategory = nil
                }
            }
            Button("Cancel", role: .cancel) {
                requestedCategory = nil
            }
        }
    }

    /// Sorted categories by number of expenses
    var sortedCategories: [Category] {
        allCategories.sorted {
            ($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0)
        }
    }
}

#Preview {
    CategoriesView()
}
