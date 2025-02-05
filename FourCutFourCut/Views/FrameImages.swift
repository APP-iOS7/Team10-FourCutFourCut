import SwiftUI

struct FrameImages: View {
    @Binding var displayedImages: [Image?]
    var backgroundImage: String?

    var body: some View {
        ZStack {
            // 배경 이미지 설정
            if let bgImage = backgroundImage {
                Image(bgImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .clipped()
//                    .ignoresSafeArea()
                
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // 화면 크기 맞추기
                    .clipped()
            } else {
                Color.black
                    .ignoresSafeArea()
            }

            // VStack 설정
            VStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    if let image = displayedImages[index] {
                        ZStack {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 150)
                                .clipped()
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
                            .position(x: 190, y: 20) // 버튼 위치 조정
                        }
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 250, height: 150)
                    }
                }
            }
            .padding(10) // 내부 여백 추가
        }
    }
}

#Preview {
    ContentView()
}
