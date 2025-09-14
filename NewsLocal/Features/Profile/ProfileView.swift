import SwiftUI

struct ProfileView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            StandardPageWrapper(
                title: "Profile",
                showCategories: false,
                selectedCategory: nil,
                selectedTab: selectedTab,
                onCategorySelected: { _ in },
                onTabSelected: { tab in
                    selectedTab = tab
                }
            ) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Profile Image
                            AsyncImage(url: viewModel.user.profileImageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle()
                                    .fill(.blue.opacity(0.1))
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40, weight: .medium))
                                            .foregroundColor(.blue)
                                    )
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            VStack(spacing: 4) {
                                Text(viewModel.user.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text(viewModel.user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                // Reading Level Badge
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(viewModel.readingLevelColor)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(viewModel.readingLevel)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(viewModel.readingLevelColor)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(viewModel.readingLevelColor.opacity(0.1))
                                )
                            }
                        }
                        .padding(.top, 20)
                        
                        // Statistics Cards
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                StatisticsCard(
                                    title: "Articles Read",
                                    value: "\(viewModel.user.statistics.articlesRead)",
                                    icon: "book.fill",
                                    color: .blue
                                )
                                
                                StatisticsCard(
                                    title: "Liked",
                                    value: "\(viewModel.user.statistics.articlesLiked)",
                                    icon: "heart.fill",
                                    color: .red
                                )
                            }
                            
                            HStack(spacing: 12) {
                                StatisticsCard(
                                    title: "Saved",
                                    value: "\(viewModel.user.statistics.articlesShared)",
                                    icon: "bookmark.fill",
                                    color: .green
                                )
                                
                                StatisticsCard(
                                    title: "Streak",
                                    value: "\(viewModel.user.statistics.readingStreak) days",
                                    icon: "flame.fill",
                                    color: .orange,
                                    subtitle: "Keep it up!"
                                )
                            }
                        }
                        
                        // Quick Access Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick Access")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 4)
                            
                            HStack(spacing: 12) {
                                QuickAccessButton(
                                    icon: "clock.fill",
                                    title: "Recent",
                                    count: viewModel.recentArticles.count,
                                    color: .blue
                                ) {
                                    print("📚 Recent articles tapped!")
                                }
                                
                                QuickAccessButton(
                                    icon: "bookmark.fill",
                                    title: "Saved",
                                    count: viewModel.savedArticles.count,
                                    color: .green
                                ) {
                                    print("💾 Saved articles tapped!")
                                }
                                
                                QuickAccessButton(
                                    icon: "heart.fill",
                                    title: "Liked",
                                    count: viewModel.user.statistics.articlesLiked,
                                    color: .red
                                ) {
                                    print("❤️ Liked articles tapped!")
                                }
                            }
                        }
                        
                        // Profile Options
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Settings")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 12) {
                                ProfileOptionRow(
                                    icon: "person.circle",
                                    title: "Edit Profile",
                                    action: {
                                        print("👤 Edit Profile tapped!")
                                    }
                                )
                            
                            ProfileOptionRow(
                                icon: "bell",
                                title: "Notifications",
                                action: {
                                    print("🔔 Profile Notifications tapped!")
                                }
                            )
                            
                            ProfileOptionRow(
                                icon: "gear",
                                title: "Settings",
                                action: {
                                    print("⚙️ Settings tapped!")
                                }
                            )
                            
                            ProfileOptionRow(
                                icon: "questionmark.circle",
                                title: "Help & Support",
                                action: {
                                    print("❓ Help & Support tapped!")
                                }
                            )
                            
                            ProfileOptionRow(
                                icon: "info.circle",
                                title: "About",
                                action: {
                                    print("ℹ️ About tapped!")
                                }
                            )
                        }
                        
                        // Bottom padding for bottombar
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(selectedTab: .constant(.profile))
    }
}
