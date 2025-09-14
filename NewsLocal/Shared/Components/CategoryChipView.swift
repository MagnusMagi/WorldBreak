import SwiftUI

/// Category chip component for filtering news
struct CategoryChipView: View {
    let category: NewsCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: categoryIcon)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : categoryColor)
                
                Text(category.displayName)
                    .font(DesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : categoryColor)
            }
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(
                isSelected ? categoryColor : categoryColor.opacity(0.1)
            )
            .cornerRadius(DesignSystem.CornerRadius.full)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryColor: Color {
        switch category {
        case .general:
            return DesignSystem.Colors.categoryGeneral
        case .technology:
            return DesignSystem.Colors.categoryTechnology
        case .business:
            return DesignSystem.Colors.categoryBusiness
        case .sports:
            return DesignSystem.Colors.categorySports
        case .health:
            return DesignSystem.Colors.categoryHealth
        case .science:
            return DesignSystem.Colors.categoryScience
        case .entertainment:
            return DesignSystem.Colors.categoryEntertainment
        case .politics:
            return DesignSystem.Colors.categoryPolitics
        case .world:
            return DesignSystem.Colors.categoryWorld
        case .local:
            return DesignSystem.Colors.categoryLocal
        default:
            return DesignSystem.Colors.categoryGeneral
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .general:
            return "newspaper"
        case .technology:
            return "laptopcomputer"
        case .business:
            return "chart.line.uptrend.xyaxis"
        case .sports:
            return "sportscourt"
        case .health:
            return "heart"
        case .science:
            return "atom"
        case .entertainment:
            return "tv"
        case .politics:
            return "building.2"
        case .world:
            return "globe"
        case .local:
            return "location"
        default:
            return "newspaper"
        }
    }
}


// MARK: - Preview

struct CategoryChipView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                CategoryChipView(
                    category: .technology,
                    isSelected: true,
                    onTap: {}
                )
                
                CategoryChipView(
                    category: .business,
                    isSelected: false,
                    onTap: {}
                )
                
                CategoryChipView(
                    category: .sports,
                    isSelected: false,
                    onTap: {}
                )
            }
            
            HStack(spacing: DesignSystem.Spacing.sm) {
                CategoryChipView(
                    category: .health,
                    isSelected: false,
                    onTap: {}
                )
                
                CategoryChipView(
                    category: .science,
                    isSelected: true,
                    onTap: {}
                )
                
                CategoryChipView(
                    category: .entertainment,
                    isSelected: false,
                    onTap: {}
                )
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
