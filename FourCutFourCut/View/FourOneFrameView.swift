import SwiftUI


struct FourOneFrame: View {
    @Binding var displayedImages: [Image?]
    var showDeleteButtons: Bool
    let frameSize: CGSize
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { index in
                if let image = displayedImages[index] {
                    ZStack {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: frameSize.width * 0.8, height: frameSize.height / 4 - 35)
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
                            .position(x: frameSize.width * 0.5, y: 25)
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: frameSize.width * 0.8, height: frameSize.height / 4 - 35)
                }
            }
        }
        .padding(.top, 30)
        .padding(.bottom, 80)
    }
}

#Preview {
    ContentView()
}

