//
//  FormDemo.swift
//  AirBnb
//
//  Created by Sagar Kulkarni on 26/02/25.
//

import SwiftUI

enum ActiveTextfield: Hashable {
    case firstname
    case lastname
    case address
    case text
    case email
    case birthdate
}

struct FormDemo: View {
    
    @State private var firstname: String = String()
    @State private var lastname: String = String()
    @State private var address: String = String()
    @State private var email: String = String()
    @State private var birthdate: String = String()
    
    @FocusState private var activeTextfield: ActiveTextfield?
    
    @Namespace private var activeFieldStroke
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ABSection {
                        ABTextField("First name on ID", text: $firstname)
                            .highlightOnFocus(
                                $activeTextfield,
                                value: .firstname,
                                namespace: activeFieldStroke,
                                identifier: "af"
                            )
                        
                        ABTextField("Last name on ID", text: $lastname)
                            .highlightOnFocus(
                                $activeTextfield,
                                value: .lastname,
                                namespace: activeFieldStroke,
                                identifier: "af"
                            )
                                                                            
                    } header: {
                        Text("Legal name")
                            .textCase(.none)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    } footer: {
                        Text("Make sure this matches the name on your government ID. If you go by another name, you can add a preferred first name.")
                            .font(.caption2)
                    }
                    
                    ABSection {
                        ABPickerView(placeholder: "Birthdate", value: LocalizedStringKey(birthdate)) {
                            activeTextfield = nil
                            activeTextfield = .birthdate
                            // open date picker
                        }
                        .focusable(activeTextfield == .birthdate)
                        .highlightOnFocus(
                            $activeTextfield,
                            value: .birthdate,
                            namespace: activeFieldStroke,
                            identifier: "af2"
                        )
                        
                    } header: {
                        Text("Date of birth")
                            .textCase(.none)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    } footer: {
                        Text("To sign up, you need to be at least 18. Your birthday won't be shared with other people who use Airbnb.")
                            .font(.caption2)
                    }
                    
                    ABSection {
                        ABTextField("Email", text: $email)
                            .highlightOnFocus(
                                $activeTextfield,
                                value: .email,
                                namespace: activeFieldStroke,
                                identifier: "af1"
                            )
                        
                    } header: {
                        Text("Email")
                            .textCase(.none)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    } footer: {
                        Text("We'll email you trip confirmations and receipts.")
                            .font(.caption2)
                    }
                    
                    ABSection {
                        ABTextEditor("Current address", text: $address)
                            .highlightOnFocus(
                                $activeTextfield,
                                value: .address,
                                namespace: activeFieldStroke,
                                identifier: "af"
                            )
                        
                    } header: {
                        Text("Address")
                            .textCase(.none)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    } footer: {
                        Text("We'll verify your address and use it for delivery of your purchases.")
                            .font(.caption2)
                    }
                }
                .animation(.smooth(duration: 0.3), value: activeTextfield)
            }
            .navigationTitle("Form")
            .safeAreaInset(edge: .bottom, alignment: .center, spacing: 20) {
                if activeTextfield == nil {
                    Button {
                        activeTextfield = nil
                    } label: {
                        Text("Continue".uppercased())
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal)
                    .padding(.top)
                    .background(.thinMaterial)
                    .mask {
                        Rectangle()
                            .fill(.linearGradient(colors: [Color.black, Color.black.opacity(0.4), Color.clear], startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.0)))
                            .ignoresSafeArea()
                    }
                }
            }
        }
    }
}

extension View {
    func highlightOnFocus<Value: Hashable>(_ binding: FocusState<Value?>.Binding, value: Value, namespace: Namespace.ID, identifier: String) -> some View {
        modifier(HighlightOnFocusViewModifier(binding, value: value, namespace: namespace, identifier: identifier))
    }
}

struct HighlightOnFocusViewModifier<Value: Hashable>: ViewModifier {
    
    var binding: FocusState<Value?>.Binding
    let value: Value
    let namespace: Namespace.ID
    let identifier: String
    
    init(_ binding: FocusState<Value?>.Binding, value: Value, namespace: Namespace.ID, identifier: String) {
        self.binding = binding
        self.value = value
        self.namespace = namespace
        self.identifier = identifier
    }
    
    func body(content: Content) -> some View {
        content
            .focused(binding, equals: value)
            .overlay {
                if binding.wrappedValue == value {
                    RoundedRectangle(cornerRadius: 8, style: .circular)
                        .stroke(.primary, lineWidth: 2)
                        .matchedGeometryEffect(id: identifier, in: namespace)
                }
            }
    }
}

struct ABPickerView: View {
    let placeholder: LocalizedStringKey
    let value: LocalizedStringKey
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(placeholder)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.down")
                .foregroundStyle(.primary)
                .fontWeight(.medium)
        }
        .padding()
        .contentShape(.rect)
        .onTapGesture {
            onTap()
        }
    }
}

struct ABTextField: View {
        
    let placeholder: LocalizedStringKey
    @Binding var text: String
    
    init(_ placeholder: LocalizedStringKey, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text.projectedValue
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .foregroundStyle(.primary)
    }
}

struct ABTextEditor: View {
        
    let placeholder: LocalizedStringKey
    @Binding var text: String
    
    init(_ placeholder: LocalizedStringKey = "", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text.projectedValue
    }
    
    var body: some View {
        TextEditor(text: $text)
            .frame(height: 100)
            .scrollContentBackground(.hidden)
            .contentMargins(.horizontal, 12, for: .scrollContent)
            .contentMargins(.vertical, 6, for: .scrollContent)
            .foregroundStyle(.primary)
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 13)
                        .foregroundStyle(.secondary)
                }
            }
    }
}

struct ABSection<Content, Header, Footer>: View where Content: View, Header: View, Footer: View {
        
    @ViewBuilder let content: Content
    @ViewBuilder let header: Header
    @ViewBuilder let footer: Footer
    
    var body: some View {
        VStack(spacing: 12) {
            header
                .frame(maxWidth: .infinity, alignment: .leading)
            Group(subviews: content) { subviews in
                VStack(spacing: 0) {
                    ForEach(subviews.indices, id: \.self) { index in
                        subviews[index]
                        
                        if index < subviews.count - 1 {
                            Rectangle()
                                .frame(height: 1)
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                }
            }
            .foregroundStyle(.secondary)
                
            footer
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

#Preview {
    FormDemo()
}
