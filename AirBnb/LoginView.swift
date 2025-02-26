//
//  LoginView.swift
//  AirBnb
//
//  Created by Sagar Kulkarni on 26/02/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            
            DividerView {
                Text("or")
            }
            
            socialLoginOptions
        }
        .padding()
    }
    
    private var socialLoginOptions: some View {
        VStack(spacing: 16) {
            Button("Continue with email", systemImage: "envelope.fill", action: {})
            Button("Continue with Apple", systemImage: "apple.logo", action: {})
            Button("Continue with Google", systemImage: "app", action: {})
            Button("Continue with Facebook", systemImage: "app", action: {})
        }
        .buttonStyle(SocialButtonStyle(alignment: .leading))
    }
}

#Preview {
    LoginView()
}


struct DividerView<Content: View>: View {
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        HStack {
            divider
            content()
            divider
        }
    }
    
    private var divider: some View {
        VStack {
            Divider()
        }
    }
}

struct SocialButtonStyle: ButtonStyle {
    
    let alignment: HorizontalAlignment
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(AlignableLabelStyle(iconAlignment: alignment))
            .padding(.all, 12)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.primary, lineWidth: 1)
                
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.4))
                        .transition(.opacity)
                }
            }
            .animation(.smooth, value: configuration.isPressed)
    }
}

extension LabelStyle where Self == AlignableLabelStyle {
    static var alignable: AlignableLabelStyle {
        AlignableLabelStyle()
    }
}

struct AlignableLabelStyle: LabelStyle {
    
    @State private var _titleHPadding: CGFloat = .zero

    private var _resolvedAlignment: HorizontalAlignment {
        iconAlignment == .trailing ? .trailing : .leading
    }
    
    let iconAlignment: HorizontalAlignment
    
    init(iconAlignment: HorizontalAlignment = .leading) {
        self.iconAlignment = iconAlignment
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.icon
                .getSize { size in
                    _titleHPadding = size.width + 8
                }
                .frame(maxWidth: .infinity, alignment: Alignment(horizontal: iconAlignment, vertical: .center))
            
            configuration.title
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, _titleHPadding)
        }
        .contentShape(.rect)
    }
}

extension View {
    func getSize(onSizeChange: @escaping (CGSize) -> Void) -> some View {
        background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: onSizeChange)
    }
}

enum SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
