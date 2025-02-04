//
//  FrameImages.swift
//  FourCutFourCut
//
//  Created by 최시온 on 2/4/25.
//

import SwiftUI
import PhotosUI

struct FrameImages: View {
    @State private var displayedImages: [Image?]
    
    init(displayedImages: [Image?]) {
        self.displayedImages = displayedImages
    }

    var body: some View {
        ZStack {
            // 선택된 사진들을 배치할 VStack
            VStack(spacing: 8) {
                ForEach(0..<4) { index in
                    if let image = displayedImages[index] {
                        ZStack {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 150)
                                .clipped()
                            Button(action: {
                                removeImage(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                                    .padding(5)
                            }
                            .position(x: 190, y: 20) // 버튼 위치 조정
                        }
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 250, height: 150)
                    }
                }
            }
            .padding()
        }
    }
    
    private func removeImage(at index: Int) {
        if index < displayedImages.count {
            displayedImages[index] = nil
        }
    }
}


#Preview {
    FrameImages(displayedImages: [nil, nil, nil, nil])
}
