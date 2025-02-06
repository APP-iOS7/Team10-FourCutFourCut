//
//  TwoTwoFrameView.swift
//  FourCutFourCut
//
//  Created by 최시온 on 2/5/25.
//

import SwiftUI

struct TwoTwoFrameView: View {
    @Binding var displayedImages: [Image?]
    var showDeleteButtons: Bool
    let frameSize: CGSize
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<4, id: \.self) { index in
                if let image = displayedImages[index] {
                    ZStack {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: frameSize.width / 2 - 20, height: frameSize.height / 2 - 20)
                            .clipped()
                        if showDeleteButtons {
                            Button(action: {
                                displayedImages[index] = nil
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                                    .padding(5)
                            }
                            .position(x: frameSize.width / 4, y: 25)
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: frameSize.width / 2 - 20, height: frameSize.height / 2 - 20)
                }
            }
        }
//        .padding(.top, 0)
        //.padding(.bottom, 170)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentView()
}
