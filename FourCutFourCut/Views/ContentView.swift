import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var displayedImages: [Image?] = Array(repeating: nil, count: 4)
    @State private var showingSaveAlert = false
    @State private var backgroundImage: String? = nil
    
    let backgroundImages = ["bg1", "bg2", "bg3", "bg4", "bg5"]
    
    var body: some View {
        VStack {
            Text("포컷포컷")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top, 20)
            
            Spacer() // 상단 여백을 위한 Spacer
            
            FrameImages(displayedImages: $displayedImages, backgroundImage: backgroundImage)
                .frame(width: 250, height: 650)
            
            // 배경 이미지 선택 버튼들
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(backgroundImages, id: \.self) { imageName in
                        Button(action: {
                            backgroundImage = imageName
                        }) {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: backgroundImage == imageName ? 3 : 0)
                                )
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            
            // 하단 버튼들
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
        .onChange(of: selectedPhotos) { _, _ in
            loadTransferable()
        }
        .alert("저장 완료", isPresented: $showingSaveAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("이미지가 앨범에 저장되었습니다.")
        }
    }
    
    private func saveToPhotoAlbum() {
        let renderer = ImageRenderer(content: FrameImages(displayedImages: $displayedImages, backgroundImage: backgroundImage))
        renderer.scale = UIScreen.main.scale
        
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            showingSaveAlert = true
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
    
    private func removeImage(at index: Int) {
        if index < displayedImages.count {
            displayedImages[index] = nil
        }
    }
}

#Preview {
    ContentView()
}
