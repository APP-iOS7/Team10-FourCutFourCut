//
//  ContentView.swift
//  FourCutFourCut
//
//  Created by 조영민 on 2/4/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    let frameWidth: CGFloat = 300
    let frameHeight: CGFloat = 400
    let phtoSpacing: CGFloat = 10
    
    var body: some View {
        ZStack {
            // 배경
            Color.black
                .ignoresSafeArea()
            
            // 메인 프레임
            VStack(spacing: 10) {
                // 상단 타이틀
                Text("포컷포컷")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // 사진 프레임들
                VStack(spacing: 8) {
                    ForEach(0..<4) { _ in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 250, height: 150)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Spacer()
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("사진 선택하기")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                        }
                    }
                }
            }
            .padding()
        }
    }
}




#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
