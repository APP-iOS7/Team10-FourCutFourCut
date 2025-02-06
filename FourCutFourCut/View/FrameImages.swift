import SwiftUI

struct FrameImages: View {
    @Binding var displayedImages: [Image?]
    var backgroundImage: String?
    var showDeleteButtons: Bool = true
    @Binding var frame: Frame
    
    var body: some View {
        ZStack {
            if let bgImage = backgroundImage {
                Image(bgImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.size.width, height: frame == .two_two ? 550 : 680)
                    .clipped()
                    //.border(.red, width: 1)
            } else {
                Color.black
                    .frame(width: frame.size.width, height: frame.size.height)
            }
            
            if frame == .four_one {
                FourOneFrame(displayedImages: $displayedImages, showDeleteButtons: showDeleteButtons, frameSize: frame.size)
            } else if frame == .two_two {
                TwoTwoFrameView(displayedImages: $displayedImages, showDeleteButtons: showDeleteButtons, frameSize: frame.size)
            }
            
        }
    }
}

#Preview {
    ContentView()
}


