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
                return isDark ? .white.opacity(0.9) : .black
            } else {
                return isDark ? .black.opacity(0.5) : .white
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
                return isDark ? .gray.opacity(0.7) : .black.opacity(0.7)
            }
        }()
        
        Button {
            toggleAction()
        } label: {
            Text("\(category.emoji)\(category.rawValue)")
                .foregroundStyle(textColor)
                .padding(.vertical, 6)
                .padding(.horizontal, 15)
            
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(backgroundColor)
                .stroke(borderColor, lineWidth: 1)
        }
        .padding(.vertical, 3)
    }
}
