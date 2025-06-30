import SwiftUI

struct CustomTextFiled: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray.opacity(0.3))
                }
                .frame(height: 47)
                .cornerRadius(12)
                .padding(.horizontal, 15)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if !isEditing {
                    isTextFocused = false
                }
            })
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 16)
            .frame(height: 47)
            .font(.custom("Quicksand-Regular", size: 15))
            .cornerRadius(9)
            .foregroundStyle(.black)
            .focused($isTextFocused)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Sand(size: 16, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                    .frame(height: 47)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray.opacity(0.3))
                }
                .frame(height: 47)
                .cornerRadius(12)
                .padding(.horizontal, 15)
            
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("Quicksand-Regular", size: 16))
                        .foregroundStyle(.black)
                        .focused($isTextFocused)
                } else {
                    TextField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("Quicksand-Regular", size: 16))
                        .foregroundStyle(.black)
                        .focused($isTextFocused)
                }
                
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
            }
            .padding(.horizontal, 16)
            .frame(height: 47)
            .cornerRadius(9)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .font(.custom("Quicksand-Regular", size: 16))
                    .foregroundColor(Color(red: 153/255, green: 173/255, blue: 200/255))
                    .frame(height: 47)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color(red: 255/255, green: 245/255, blue: 0/255) : Color(red: 146/255, green: 140/255, blue: 0/255))
                .frame(width: 43, height: 21)
                .overlay(
                    Circle()
                        .fill(.black)
                        .frame(width: 12, height: 12)
                        .offset(x: configuration.isOn ? 12 : -12)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
