import SwiftUI

/// Standardized ProfileView with Header, BottomBar and Design System integration
struct ProfileView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingReadingHistory = false
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var showingNotificationSettings = false
    @State private var showingThemeSettings = false
    @State private var showingPrivacySettings = false
    @State private var showingHelpSupport = false
    @State private var showingAbout = false
    
    var body: some View {
        ProfilePageWrapper(
            title: "Profile",
            selectedTab: selectedTab,
            onTabSelected: { tab in
                selectedTab = tab
            }
        ) {
            List {
                // Profile Header Section
                Section {
                    ProfileHeader(
                        user: viewModel.user,
                        readingLevel: viewModel.readingLevel,
                        readingLevelColor: viewModel.readingLevelColor,
                        onEditProfile: {
                            showingEditProfile = true
                        }
                    )
                }
                
                // Statistics Section
                Section(header: ProfileSectionHeader(title: "Statistics", icon: "chart.bar.fill", color: DesignSystem.Colors.primary)) {
                    StatisticsRow(
                        icon: "book.fill",
                        title: "Articles Read",
                        value: "\(viewModel.user.statistics.articlesRead)",
                        color: DesignSystem.Colors.primary
                    )
                    
                    StatisticsRow(
                        icon: "heart.fill",
                        title: "Liked Articles",
                        value: "\(viewModel.user.statistics.articlesLiked)",
                        color: DesignSystem.Colors.error
                    )
                    
                    StatisticsRow(
                        icon: "bookmark.fill",
                        title: "Saved Articles",
                        value: "\(viewModel.user.statistics.articlesShared)",
                        color: DesignSystem.Colors.success
                    )
                    
                    StatisticsRow(
                        icon: "flame.fill",
                        title: "Reading Streak",
                        value: "\(viewModel.user.statistics.readingStreak) days",
                        color: DesignSystem.Colors.warning
                    )
                    
                    StatisticsRow(
                        icon: "clock.fill",
                        title: "Time Spent",
                        value: viewModel.formattedTimeSpent,
                        color: DesignSystem.Colors.info
                    )
                }
                
                // Quick Access Section
                Section(header: ProfileSectionHeader(title: "Quick Access", icon: "bolt.fill", color: DesignSystem.Colors.warning)) {
                    ProfileListItem(
                        icon: "clock.fill",
                        title: "Reading History",
                        subtitle: "View your recent articles",
                        badge: "\(viewModel.recentArticles.count)",
                        color: DesignSystem.Colors.primary
                    ) {
                        showingReadingHistory = true
                    }
                    
                    ProfileListItem(
                        icon: "heart.fill",
                        title: "Liked Articles",
                        subtitle: "Articles you've liked",
                        badge: "\(viewModel.user.statistics.articlesLiked)",
                        color: DesignSystem.Colors.error
                    ) {
                        // TODO: Implement liked articles view
                        print("❤️ Liked articles tapped!")
                    }
                    
                    ProfileListItem(
                        icon: "bookmark.fill",
                        title: "Saved Articles",
                        subtitle: "Your bookmarked articles",
                        badge: "\(viewModel.user.statistics.articlesShared)",
                        color: DesignSystem.Colors.success
                    ) {
                        // TODO: Implement saved articles view
                        print("💾 Saved articles tapped!")
                    }
                    
                    ProfileListItem(
                        icon: "magnifyingglass",
                        title: "Search History",
                        subtitle: "Your recent searches",
                        color: DesignSystem.Colors.info
                    ) {
                        // TODO: Implement search history view
                        print("🔍 Search history tapped!")
                    }
                }
                
                // Account Section
                Section(header: ProfileSectionHeader(title: "Account", icon: "person.circle.fill", color: DesignSystem.Colors.primary)) {
                    ProfileListItem(
                        icon: "person.circle",
                        title: "Edit Profile",
                        subtitle: "Update your personal information",
                        color: DesignSystem.Colors.primary
                    ) {
                        showingEditProfile = true
                    }
                    
                    ProfileListItem(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Manage your notification preferences",
                        color: DesignSystem.Colors.warning
                    ) {
                        showingNotificationSettings = true
                    }
                    
                    ProfileListItem(
                        icon: "paintbrush.fill",
                        title: "Appearance",
                        subtitle: "Theme and display settings",
                        color: DesignSystem.Colors.info
                    ) {
                        showingThemeSettings = true
                    }
                    
                    ProfileListItem(
                        icon: "lock.fill",
                        title: "Privacy & Security",
                        subtitle: "Data sharing and privacy controls",
                        color: DesignSystem.Colors.success
                    ) {
                        showingPrivacySettings = true
                    }
                }
                
                // Support Section
                Section(header: ProfileSectionHeader(title: "Support", icon: "questionmark.circle.fill", color: DesignSystem.Colors.warning)) {
                    ProfileListItem(
                        icon: "questionmark.circle",
                        title: "Help & Support",
                        subtitle: "Get help and contact support",
                        color: DesignSystem.Colors.warning
                    ) {
                        showingHelpSupport = true
                    }
                    
                    ProfileListItem(
                        icon: "info.circle",
                        title: "About",
                        subtitle: "App version and information",
                        color: DesignSystem.Colors.secondary
                    ) {
                        showingAbout = true
                    }
                    
                    ProfileListItem(
                        icon: "star.fill",
                        title: "Rate App",
                        subtitle: "Rate NewsLocal on the App Store",
                        color: DesignSystem.Colors.accent
                    ) {
                        // TODO: Implement app rating
                        print("⭐ Rate app tapped!")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .refreshable {
                viewModel.refreshData()
            }
        }
        .sheet(isPresented: $showingReadingHistory) {
            ReadingHistoryView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showingNotificationSettings) {
            NotificationSettingsView()
        }
        .sheet(isPresented: $showingThemeSettings) {
            ThemeSettingsView()
        }
        .sheet(isPresented: $showingPrivacySettings) {
            PrivacySettingsView()
        }
        .sheet(isPresented: $showingHelpSupport) {
            HelpSupportView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(selectedTab: .constant(.profile))
    }
}
