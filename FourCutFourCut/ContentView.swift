import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var displayedImages: [Image?] = Array(repeating: nil, count: 4)
    
    @State private var backgroundImage: String? = nil  // 선택된 배경 이미지
    
    let backgroundImages = ["bg1", "bg2", "bg3", "bg4", "bg5"] // Assets에 저장된 이미지 이름
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경 이미지 설정
                if let bgImage = backgroundImage {
                    Image(bgImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea()
                } else {
                    Color.black
                        .ignoresSafeArea()
                }
                
                VStack {
                    Text("포컷포컷")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // 사진을 정확히 중앙에 배치
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
                    .frame(width: 250, height: 650, alignment: .center) // 중앙 정렬
                    
                    Spacer()
                    
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
                    .padding(.bottom, 10)
                    
                    // ✅ 배경 이미지 선택 버튼 목록
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(backgroundImages, id: \.self) { imageName in
                                Button(action: {
                                    backgroundImage = imageName // 선택된 배경 변경
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
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height) // ✅ 전체 크기 맞춤
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
        
        private func removeImage(at index: Int) {
            if index < displayedImages.count {
                displayedImages[index] = nil
            }
        }
    }
    
    #Preview {
        ContentView()
    }
}
