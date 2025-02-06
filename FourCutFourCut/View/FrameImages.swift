import SwiftUI

struct FrameImages: View {
    @Binding var displayedImages: [Image?]
       var backgroundImage: String?
       var showDeleteButtons: Bool = true
       @Binding var frame: Frame
       
       var body: some View {
           ZStack {
               if let bgImage = backgroundImage {
                   if frame == .four_one {
                       Image(bgImage)
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: frame.size.width, height: frame.size.height)
                           .clipped()
                   } else {
                       Image(bgImage)
                           .resizable()
                           .frame(width: frame.size.width, height: frame.size.height)
                           .clipped()
                   }
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


