import UIKit

enum CollectionItem {
    case emoji(String)
    case color(UIColor)
}

struct CollectionData {
    static let emojis: [CollectionItem] = [
        .emoji("😀"), .emoji("😎"), .emoji("🥳"),
        .emoji("🤓"), .emoji("🤖"), .emoji("👾"),
        .emoji("🐶"), .emoji("🐱"), .emoji("🦊"),
        .emoji("🐻"), .emoji("🐼"), .emoji("🐨"),
        .emoji("🍎"), .emoji("🍕"), .emoji("🍔"),
        .emoji("🍩"), .emoji("🍪"), .emoji("🍫")
    ]
    
    static let colors: [CollectionItem] = [
        .color(UIColor(hex: "#FD4C49")),
        .color(UIColor(hex: "#FF881E")),
        .color(UIColor(hex: "#007BFA")),
        .color(UIColor(hex: "#6E44FE")),
        .color(UIColor(hex: "#33CF69")),
        .color(UIColor(hex: "#E66DD4")),
        .color(UIColor(hex: "#F9D4D4")),
        .color(UIColor(hex: "#34A7FE")),
        .color(UIColor(hex: "#46E69D")),
        .color(UIColor(hex: "#35347C")),
        .color(UIColor(hex: "#FF674D")),
        .color(UIColor(hex: "#FF99CC")),
        .color(UIColor(hex: "#F6C48B")),
        .color(UIColor(hex: "#7994F5")),
        .color(UIColor(hex: "#832CF1")),
        .color(UIColor(hex: "#AD56DA")),
        .color(UIColor(hex: "#8D72E6")),
        .color(UIColor(hex: "#2FD058"))
    ]
}
