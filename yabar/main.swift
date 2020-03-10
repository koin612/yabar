import AppKit

let app = NSApplication.shared
NSApp.setActivationPolicy(.accessory)
let controller = YabarController(
    Yabai.queryDisplays())

app.delegate = controller
app.run()
