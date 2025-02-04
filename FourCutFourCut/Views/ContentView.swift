import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var displayedImages: [Image?] = Array(repeating: nil, count: 4)
    @State private var backgroundImage: String? = nil

    let backgroundImages = ["bg1", "bg2", "bg3", "bg4", "bg5"]

    var body: some View {
        VStack {
            Text("포컷포컷")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top, 20)

            FrameImages(displayedImages: $displayedImages, backgroundImage: backgroundImage)
                .frame(width: 250, height: 650) // Frame의 크기 설정

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
        .onChange(of: selectedPhotos) {
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
}
