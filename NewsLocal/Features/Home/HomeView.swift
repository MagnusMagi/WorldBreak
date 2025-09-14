import SwiftUI
import Combine

struct HomeView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        NavigationView {
            StandardPageWrapper(
                title: "Home",
                showCategories: false,
                selectedCategory: nil,
                selectedTab: .home,
                onCategorySelected: { _ in },
                onTabSelected: { tab in
                    selectedTab = tab
                }
            ) {
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.xl) {
                        // Welcome Section
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            // App Logo/Icon
                            VStack(spacing: DesignSystem.Spacing.md) {
                                Image(systemName: "newspaper.circle.fill")
                                    .font(.system(size: 80, weight: .light))
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                Text("NewsLocal")
                                    .font(DesignSystem.Typography.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                
                                Text("Your trusted source for local and global news")
                                    .font(DesignSystem.Typography.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, DesignSystem.Spacing.lg)
                            }
                            .padding(.vertical, DesignSystem.Spacing.xl)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(DesignSystem.Spacing.lg)
                        .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        
                        // Quick Actions Section
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            HStack {
                                Text("Quick Actions")
                                    .font(DesignSystem.Typography.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: DesignSystem.Spacing.md) {
                                HomeQuickActionCard(
                                    title: "Search",
                                    subtitle: "Find specific topics",
                                    icon: "magnifyingglass",
                                    color: DesignSystem.Colors.primary
                                ) {
                                    selectedTab = .search
                                }
                                
                                HomeQuickActionCard(
                                    title: "Notifications",
                                    subtitle: "Stay updated",
                                    icon: "bell",
                                    color: DesignSystem.Colors.secondary
                                ) {
                                    selectedTab = .notifications
                                }
                                
                                HomeQuickActionCard(
                                    title: "Profile",
                                    subtitle: "Manage settings",
                                    icon: "person.circle",
                                    color: DesignSystem.Colors.accent
                                ) {
                                    selectedTab = .profile
                                }
                                
                                HomeQuickActionCard(
                                    title: "Home",
                                    subtitle: "Back to home",
                                    icon: "house",
                                    color: DesignSystem.Colors.info
                                ) {
                                    selectedTab = .home
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(DesignSystem.Spacing.lg)
                        .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        
                        // Features Section
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            HStack {
                                Text("Features")
                                    .font(DesignSystem.Typography.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                HomeFeatureRow(
                                    icon: "globe",
                                    title: "Global Coverage",
                                    description: "Stay informed with news from around the world"
                                )
                                
                                HomeFeatureRow(
                                    icon: "bell",
                                    title: "Breaking News",
                                    description: "Get instant notifications for important updates"
                                )
                                
                                HomeFeatureRow(
                                    icon: "heart",
                                    title: "Personalized",
                                    description: "Customize your news feed based on your interests"
                                )
                                
                                HomeFeatureRow(
                                    icon: "shield",
                                    title: "Trusted Sources",
                                    description: "Verified and reliable news from credible sources"
                                )
                            }
                            .padding(.horizontal, DesignSystem.Spacing.lg)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(DesignSystem.Spacing.lg)
                        .shadow(color: DesignSystem.Colors.shadow, radius: 2, x: 0, y: 1)
                        .padding(.horizontal, DesignSystem.Spacing.md)
                        
                        // Bottom spacing
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.top, DesignSystem.Spacing.lg)
                }
            }
        }
    }
    
}

// MARK: - Home Quick Action Card

struct HomeQuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(DesignSystem.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(DesignSystem.Spacing.lg)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.Spacing.md)
                    .fill(color.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Home Feature Row

struct HomeFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(DesignSystem.Colors.primary)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text(description)
                    .font(DesignSystem.Typography.caption1)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, DesignSystem.Spacing.sm)
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(.home))
    }
}