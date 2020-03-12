import AppKit

let app = NSApplication.shared
NSApp.setActivationPolicy(.accessory)
let controller = YabarController(
    Yabai.queryDisplays(),
    Yabai.querySpaces())

app.delegate = controller
app.run()
