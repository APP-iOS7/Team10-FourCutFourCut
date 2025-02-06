import SwiftUI
import PhotosUI

struct ContentView: View {
    // 선택된 사진들을 저장하는 상태 변수
    @State private var selectedPhotos: [PhotosPickerItem] = []
    // 화면에 표시될 이미지들을 저장하는 상태 변수 (최대 4개)
    @State private var displayedImages: [Image?] = Array(repeating: nil, count: 4)
    // 저장 완료 알림창 표시 여부를 제어하는 상태 변수
    @State private var showingSaveAlert = false
    // 선택된 배경 이미지를 저장하는 상태 변수
    @State private var backgroundImage: String? = "bg0"
    @State private var showDeleteButtons = true
    @State private var frame: Frame = .two_two
    
    // 사용 가능한 배경 이미지 목록
    let backgroundImages = ["bg0", "bg1", "bg2", "bg3", "bg4", "bg5"]
    
    var body: some View {
        NavigationStack {
            VStack {
               
                Spacer()
                
                ZStack {
                    FrameImages(displayedImages: $displayedImages, backgroundImage: backgroundImage, showDeleteButtons: showDeleteButtons, frame: $frame)
                        .frame(maxWidth: frame.size.width, maxHeight: frame.size.height)
                        .border(.black, width: 1)
                        .scaleEffect(0.8)
                        
                }
                .overlay(
                    Color.clear.onAppear {
                        showDeleteButtons = true
                    }
                )
                
                Spacer()
                
                // 배경 이미지 선택을 위한 가로 스크롤 뷰
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(backgroundImages, id: \.self) { imageName in
                            Button(action: {
                                // 배경 이미지 선택 시 적용
                                backgroundImage = imageName
                            }) {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                    .overlay(
                                        // 선택된 배경 이미지에 검정 테두리 표시
                                        RoundedRectangle(cornerRadius: 7)
                                            .stroke(Color.black, lineWidth: backgroundImage == imageName ? 3 : 1)
                                    )
                            }
                        }
                    }
                }
                .padding(.vertical, 10)
                // 하단 기능 버튼
                HStack(spacing: 20) {
                    // 사진 선택 버튼
                    PhotosPicker(
                        selection: $selectedPhotos,
                        maxSelectionCount: 4,
                        matching: .images
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                                .foregroundColor(.white)
                            Text("사진 선택하기")
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        .background(Color.teal)
                        .bold()
                        .cornerRadius(15)
                        .scaleEffect(1.1, anchor: .center)
                        .animation(.easeInOut(duration: 0.2), value: selectedPhotos.count)
                    }
                    
                    // 완성된 이미지 저장 버튼
                    Button(action: {
                        saveToPhotoAlbum()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.white)
                            Text("이미지 저장")
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        .bold()
                        .background(Color.green)
                        .cornerRadius(15)
                        .scaleEffect(1.1, anchor: .center)
                        .animation(.easeInOut(duration: 0.2), value: showingSaveAlert)
                    }
                }
                .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker(selection: $frame) {
                            ForEach(Frame.allCases, id: \.self) { frameOption in
                                Text(frameOption.rawValue).tag(frameOption)
                            }
                        } label: {
                            Text("Frame")
                        }

                    } label: {
                        Text("Frame")
                    }
                }
            }
            .navigationTitle("포컷포컷")
            .navigationBarTitleDisplayMode(.inline)
        }
        // 사진이 선택될 때마다 이미지 로드 함수 실행
        .onChange(of: selectedPhotos) { _, _ in
            loadTransferable()
        }
        // 저장 완료 알림창
        .alert("저장 완료", isPresented: $showingSaveAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("이미지가 앨범에 저장되었습니다.")
        }
    }
    
    // 완성된 이미지를 사진 앨범에 저장하는 함수
    private func saveToPhotoAlbum() {
        let renderer = ImageRenderer(content: ZStack {
            FrameImages(displayedImages: $displayedImages, backgroundImage: backgroundImage, showDeleteButtons: false, frame: $frame)
                .frame(width: frame.size.width, height: frame.size.height)
        })
        renderer.scale = UIScreen.main.scale
        
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            showingSaveAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showDeleteButtons = true
        }
    }
    
    // 선택된 사진들을 로드하여 화면에 표시하는 함수
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
        // PhotosPicker 재진입시 기존 선택 이미지 초기화
        selectedPhotos.removeAll()
    }
    
    // 특정 인덱스의 이미지를 제거하는 함수
    private func removeImage(at index: Int) {
        if index < displayedImages.count {
            displayedImages[index] = nil
        }
    }
}

#Preview {
    ContentView()
}
