//
//  ContentView.swift
//  FourCutFourCut
//
//  Created by 조영민 on 2/4/25.
//


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
    @State private var backgroundImage: String? = nil
    
    // 사용 가능한 배경 이미지 목록
    let backgroundImages = ["bg1", "bg2", "bg3", "bg4", "bg5"]
    
    var body: some View {
        VStack {
            Text("포컷포컷")
                .font(.title)
                .foregroundColor(.black)
                .padding(.top, 20)
            
            // 상단 여백
            Spacer()
            
            // 선택된 이미지들과 배경을 표시하는 프레임
            FrameImages(displayedImages: $displayedImages, backgroundImage: backgroundImage)
                .frame(width: 250, height: 650)
            
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
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    // 선택된 배경 이미지에 흰색 테두리 표시
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: backgroundImage == imageName ? 3 : 0)
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
                    Text("사진 선택하기")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // 완성된 이미지 저장 버튼
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
        let renderer = ImageRenderer(content: FrameImages(displayedImages: $displayedImages, backgroundImage: backgroundImage))
        renderer.scale = UIScreen.main.scale
        
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            showingSaveAlert = true
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
