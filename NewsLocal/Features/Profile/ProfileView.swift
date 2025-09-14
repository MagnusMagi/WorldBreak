import SwiftUI

struct ProfileView: View {
    @Binding var selectedTab: TabItem
    
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
                            Circle()
                                .fill(.blue.opacity(0.1))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(.blue)
                                )
                            
                            VStack(spacing: 4) {
                                Text("John Doe")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("john.doe@example.com")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Profile Options
                        VStack(spacing: 16) {
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
