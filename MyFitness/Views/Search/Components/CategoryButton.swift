import SwiftUI
import SwiftData

struct CategoryButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let category: Category
    let isSelected: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        let isDark = colorScheme == .dark
        
        let backgroundColor: Color = {
            if isSelected {
                return isDark ? .white : .black
            } else {
                return isDark ? .black : .white
            }
        }()
        
        let textColor: Color = {
            if isSelected {
                return isDark ? .black : .white
            } else {
                return isDark ? .white : .black
            }
        }()
        
        let borderColor: Color = {
            if isSelected {
                return .clear
            } else {
                return isDark ? .white : .black
            }
        }()
        
        Button {
            toggleAction()
        } label: {
            Text("\(category.emoji)\(category.rawValue)")
                .foregroundStyle(textColor)
                .padding(.horizontal, 2)
            
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        .tint(backgroundColor)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        }
        
    }
}