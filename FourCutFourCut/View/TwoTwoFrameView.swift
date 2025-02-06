import SwiftUI

struct TwoTwoFrameView: View {
    @Binding var displayedImages: [Image?]
    var showDeleteButtons: Bool
    let frameSize: CGSize
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 60), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<4, id: \.self) { index in
                if let image = displayedImages[index] {
                    ZStack {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: frameSize.width / 2 - 40, height: frameSize.height / 2 - 40)
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
                        .frame(width: frameSize.width / 2 - 40, height: frameSize.height / 2 - 100)
                        .padding(.vertical, 15)
                }
            }
        }
        .padding(.top, 20)
        .padding(.all, 50)
        .padding(.bottom, 150)
    }
}

#Preview {
    ContentView()
}
