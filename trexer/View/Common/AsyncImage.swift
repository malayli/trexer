//
//  AsyncImage.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

// Source:
// https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
//
struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init?(url: URL?, placeholder: Placeholder? = nil) {
        guard let url = url else {
            return nil
        }
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                
            } else {
                placeholder
            }
        }
        .onAppear(perform: loader.load)
        .onDisappear {
            if self.loader.image == nil {
                self.loader.cancel()
            }
        }
    }
}
