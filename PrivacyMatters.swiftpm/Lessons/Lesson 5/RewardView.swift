//
//  RewardView.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 18.02.24.
//

import SwiftUI

struct RewardView: View {
    
    @Environment(\.displayScale) var displayScale
    @State var renderedImage: Image? = nil
    
    var body: some View {
        
        GeometryReader { geo in
            CertificateView()
                .overlay(
                    ZStack {
                        if let renderedImage = renderedImage {
                            VStack {
                                Spacer()
                                
                                ShareLink(item: renderedImage, preview: SharePreview("Course Certificate", image: renderedImage))
                            }
                        }
                    }
                        .padding(.bottom, geo.size.height * 0.05)
                    
                )
        }
        .aspectRatio(0.6, contentMode: .fit)
        .frame(maxWidth: 400)
        .frame(maxHeight: 700)
        .onAppear {
            runAfter(seconds: 0.5) {
                render()
            }
        }
    }
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: CertificateView(cornerRadius: false).frame(width: 1080, height: 1920))
        
        if let uiImage = renderer.uiImage {
            withAnimation {
                renderedImage = Image(uiImage: uiImage)
            }
        }
    }
}


struct CertificateView: View {
    
    var cornerRadius: Bool = true
    
    var body: some View {
        GeometryReader { geo in
            Color.black
                .cornerRadius(cornerRadius ? 20 : 0)
                .overlay(
                    VStack(spacing: 0) {
                        
                        let smallFont = geo.size.width*0.045
                        
                        Spacer()
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: geo.size.width*0.065))
                            .padding(10)
                        
                        LUIText("PrivacyMatters")
                            .font(.system(size: geo.size.width*0.07, weight: .bold))
                        
                        LUIText("Privacy Course")
                            .font(.system(size: smallFont))
                            .opacity(0.5)
                            .padding(10)
                        
                        Spacer()
                        
                        LUIText("The owner of this certificate has successfully completed the final quiz of the privacy course \"PrivacyMatters\" on \(Date().formatted(date: .complete, time: .omitted)).\n\nThe course covered how critical data can be leaked, why privacy matters, and how to protect data.")
                            .font(.system(size: smallFont))
                            .multilineTextAlignment(.center)
                            .lineSpacing(geo.size.height * 0.015)
                            .padding(.horizontal, geo.size.width * 0.1)
                        
                        Spacer()
                        Spacer()
                        
                    }
                        .padding()
                        .foregroundStyle(.white)
                )
                .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    RewardView()
}
