//
//  ContentView.swift
//  FourCutFourCut
//
//  Created by 조영민 on 2/4/25.
//


import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var displayedImages: [UIImage?] = Array(repeating: nil, count: 4)
    @State private var showingSaveAlert = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("포컷포컷")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 280, height: 680)
                    
                    VStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            if let uiImage = displayedImages[index] {
                                ZStack {
                                    Image(uiImage: uiImage)
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
                                    .position(x: 230, y: 20)
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
                
                HStack(spacing: 20) {
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
                    
                    Button(action: {
                        saveToPhotoAlbum()
                    }) {
                        Text("이미지 저장")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onChange(of: selectedPhotos) {
            loadTransferable()
        }
        .alert("저장 완료", isPresented: $showingSaveAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("이미지가 앨범에 저장되었습니다.")
        }
    }
    
    private func saveToPhotoAlbum() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 280, height: 680))
        let uiImage = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 280, height: 680))
            
            for (index, image) in displayedImages.enumerated() {
                if let image = image {
                    
                    let aspectRatio = CGSize(width: image.size.width / image.size.height, height: 1.0)
                    let newHeight = 150
                    let newWidth = newHeight * Int(aspectRatio.width)
                    let rect = CGRect(x: 15, y: 20 + (index * 158), width: newWidth, height: newHeight)
                    
                    image.draw(in: rect)
                }
            }
        }
        
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        showingSaveAlert = true
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
                        displayedImages[index] = uiImage
                    }
                }
            }
        }
    }
    
    private func removeImage(at index: Int) {
        if index < displayedImages.count {
            displayedImages[index] = nil
        }
    }
}

#Preview {
    ContentView()
}
