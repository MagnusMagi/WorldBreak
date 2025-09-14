//
//  ImageGalleryView.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import SwiftUI

/// Image gallery view for article images
struct ImageGalleryView: View {
    let images: [URL]
    @Binding var currentIndex: Int
    @Binding var isPresented: Bool
    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
                .opacity(1.0 - abs(dragOffset.height) / 300.0)
            
            // Image carousel
            TabView(selection: $currentIndex) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, imageUrl in
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        scale = max(1.0, min(value, 3.0))
                                    }
                            )
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .offset(y: dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        if abs(value.translation.height) > 100 {
                            isPresented = false
                        } else {
                            withAnimation(.spring()) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }
                Spacer()
            }
            
            // Image counter
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(currentIndex + 1) / \(images.count)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        .padding(.trailing, 20)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            scale = 1.0
            dragOffset = .zero
        }
    }
}

/// Single image viewer with zoom and pan
struct ImageViewer: View {
    let imageUrl: URL
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / lastScale
                                    lastScale = value
                                    scale = min(max(scale * delta, 1.0), 4.0)
                                }
                                .onEnded { _ in
                                    lastScale = 1.0
                                    if scale < 1.0 {
                                        withAnimation(.spring()) {
                                            scale = 1.0
                                            offset = .zero
                                        }
                                    }
                                },
                            DragGesture()
                                .onChanged { value in
                                    if scale > 1.0 {
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                    )
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            if scale > 1.0 {
                                scale = 1.0
                                offset = .zero
                                lastOffset = .zero
                            } else {
                                scale = 2.0
                            }
                        }
                    }
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
            }
        }
    }
}

/// Thumbnail grid for image gallery
struct ImageThumbnailGrid: View {
    let images: [URL]
    @Binding var selectedIndex: Int
    let onImageSelected: (Int) -> Void
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, imageUrl in
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 80)
                .clipped()
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            selectedIndex == index ? Color.blue : Color.clear,
                            lineWidth: 2
                        )
                )
                .onTapGesture {
                    selectedIndex = index
                    onImageSelected(index)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview

struct ImageGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        let mockImages = [
            URL(string: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800")!,
            URL(string: "https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800")!,
            URL(string: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800")!
        ]
        
        VStack {
            ImageThumbnailGrid(
                images: mockImages,
                selectedIndex: .constant(0),
                onImageSelected: { _ in }
            )
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}
