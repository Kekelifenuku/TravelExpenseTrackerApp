import SwiftUI

struct IntroScreen: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to\nTripSpent")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 30)

            VStack(alignment: .leading, spacing: 25) {
                PointView(symbol: "dollarsign", title: "Track Transactions", subTitle: "Easily monitor your income and spending in one place.")
                PointView(symbol: "chart.bar.fill", title: "Visual Charts", subTitle: "Search and filter by title or category")
                PointView(symbol: "magnifyingglass", title: "Advanced Filters", subTitle: "Quickly find any transaction using smart filters.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)

            Spacer()

            Button(action: {
                isFirstTime = false // Move to main app directly
            }) {
                Text("Get Started")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .contentShape(Rectangle())
            }
            .padding(.horizontal)

        }
        .padding(15)
    }

    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(alignment: .top, spacing: 18) {
            Image(systemName: symbol)
                .font(.system(size: 26, weight: .semibold))
               
                .frame(width: 40, height: 40)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(subTitle)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    IntroScreen()
}
