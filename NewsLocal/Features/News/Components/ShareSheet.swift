//
//  ShareSheet.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI
import UIKit

/// Share sheet for sharing articles
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let excludedActivityTypes: [UIActivity.ActivityType]?
    
    init(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        self.items = items
        self.excludedActivityTypes = excludedActivityTypes
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

/// Article share content builder
struct ArticleShareContent {
    let article: NewsArticle
    
    var shareText: String {
        return "\(article.title)\n\n\(article.summary)\n\n\(article.articleUrl.absoluteString)"
    }
    
    var shareItems: [Any] {
        var items: [Any] = [shareText]
        
        // Add image if available
        if let imageUrl = article.imageUrl {
            items.append(imageUrl)
        }
        
        return items
    }
    
    var socialMediaText: String {
        return "🔥 \(article.title)\n\n\(article.summary)\n\n#NewsLocal #\(article.category.displayName)"
    }
    
    var emailSubject: String {
        return "İlginç bir haber: \(article.title)"
    }
    
    var emailBody: String {
        return """
        Merhaba,
        
        Bu haberi sizinle paylaşmak istedim:
        
        \(article.title)
        
        \(article.summary)
        
        Haberin tamamını okumak için: \(article.articleUrl.absoluteString)
        
        İyi okumalar!
        """
    }
}

/// Social media share buttons
struct SocialShareButtons: View {
    let article: NewsArticle
    let onShare: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Paylaş")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                // Twitter
                ShareButton(
                    icon: "twitter",
                    title: "Twitter",
                    color: .blue,
                    action: { shareToTwitter() }
                )
                
                // Facebook
                ShareButton(
                    icon: "facebook",
                    title: "Facebook",
                    color: .blue,
                    action: { shareToFacebook() }
                )
                
                // WhatsApp
                ShareButton(
                    icon: "whatsapp",
                    title: "WhatsApp",
                    color: .green,
                    action: { shareToWhatsApp() }
                )
                
                // Telegram
                ShareButton(
                    icon: "telegram",
                    title: "Telegram",
                    color: .blue,
                    action: { shareToTelegram() }
                )
                
                // Email
                ShareButton(
                    icon: "envelope",
                    title: "E-posta",
                    color: .gray,
                    action: { shareViaEmail() }
                )
                
                // SMS
                ShareButton(
                    icon: "message",
                    title: "SMS",
                    color: .green,
                    action: { shareViaSMS() }
                )
                
                // Copy Link
                ShareButton(
                    icon: "link",
                    title: "Link Kopyala",
                    color: .orange,
                    action: { copyLink() }
                )
                
                // More
                ShareButton(
                    icon: "ellipsis",
                    title: "Daha Fazla",
                    color: .gray,
                    action: { onShare() }
                )
            }
        }
        .padding()
    }
    
    private func shareToTwitter() {
        let shareContent = ArticleShareContent(article: article)
        let twitterText = shareContent.socialMediaText
        let encodedText = twitterText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let twitterUrl = "https://twitter.com/intent/tweet?text=\(encodedText)"
        
        if let url = URL(string: twitterUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareToFacebook() {
        let shareContent = ArticleShareContent(article: article)
        let facebookText = shareContent.shareText
        let encodedText = facebookText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let facebookUrl = "https://www.facebook.com/sharer/sharer.php?u=\(encodedText)"
        
        if let url = URL(string: facebookUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareToWhatsApp() {
        let shareContent = ArticleShareContent(article: article)
        let whatsappText = shareContent.shareText
        let encodedText = whatsappText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let whatsappUrl = "whatsapp://send?text=\(encodedText)"
        
        if let url = URL(string: whatsappUrl) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func shareToTelegram() {
        let shareContent = ArticleShareContent(article: article)
        let telegramText = shareContent.shareText
        let encodedText = telegramText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let telegramUrl = "https://t.me/share/url?url=\(encodedText)"
        
        if let url = URL(string: telegramUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareViaEmail() {
        let shareContent = ArticleShareContent(article: article)
        let emailSubject = shareContent.emailSubject
        let emailBody = shareContent.emailBody
        
        let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let mailtoUrl = "mailto:?subject=\(encodedSubject)&body=\(encodedBody)"
        
        if let url = URL(string: mailtoUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareViaSMS() {
        let shareContent = ArticleShareContent(article: article)
        let smsText = shareContent.shareText
        let encodedText = smsText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let smsUrl = "sms:?body=\(encodedText)"
        
        if let url = URL(string: smsUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    private func copyLink() {
        let shareContent = ArticleShareContent(article: article)
        UIPasteboard.general.string = shareContent.article.articleUrl.absoluteString
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Could show a toast here
        print("📋 Link kopyalandı")
    }
}

/// Individual share button
struct ShareButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SocialShareButtons(
                article: NewsArticle.mock,
                onShare: {}
            )
        }
        .background(Color(.systemGroupedBackground))
    }
}
