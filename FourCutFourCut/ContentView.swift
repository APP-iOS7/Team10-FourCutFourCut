//
//  ContentView.swift
//  FourCutFourCut
//
//  Created by 조영민 on 2/4/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ContentView: View {
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var displayedImages: [Image?] = Array(repeating: nil, count: 4)
    
    var body: some View {
        ZStack {
            // 배경
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Text("포컷포컷")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                // 프레임 이미지와 선택된 사진들
                ZStack {
                    // 선택된 사진들을 배치할 VStack
                    VStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            if let image = displayedImages[index] {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 250, height: 150)
                                    .clipped()
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 250, height: 150)
                            }
                        }
                    }
                    .padding()
                }
                
                // 사진 선택 버튼
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 4,
                    matching: .images
                ) {
                    Text("사진 선택하기")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
        }
        .onChange(of: selectedPhotos) { _ in
            loadTransferable()
        }
    }
    
    private func loadTransferable() {
        for (index, photoItem) in selectedPhotos.enumerated() {
            if index < 4 {
                photoItem.loadTransferable(type: Data.self) { result in
                    DispatchQueue.main.async {
                        guard let imageData = try? result.get(),
                              let uiImage = UIImage(data: imageData) else {
                            return
                        }
                        displayedImages[index] = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
