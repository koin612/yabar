import AppKit

class YabarController : NSObject, NSApplicationDelegate
{
    let displays: [Display]
    let spaces: [Space]
    
    init(_ displays: [Display], _ spaces: [Space])
    {
        self.displays = displays
        self.spaces = spaces
    }
    
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        displays.forEach { display in
            createStatusBar(display)
        }
    }
    
    @objc private func changeSpace(_ sender: NSButton)
    {
        Yabai.changeSpace(sender.title)
    }
    
    private func createStatusBar(_ display: Display)
    {
        let bar = NSWindow.init(
            contentRect: NSRect(
                x: display.frame.x,
                y: 0.0,
                width: display.frame.w,
                height: 26.0),
            styleMask: .borderless,
            backing: .buffered,
            defer: false)
        
        bar.contentView = createAndPopulateView(display)
        bar.backgroundColor = NSColor.init(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 1)
        bar.collectionBehavior = [
            .canJoinAllSpaces,
//            .transient,
            .fullScreenNone,
            .stationary,
            .ignoresCycle]
        bar.isOpaque = false
        bar.level = .floating
        bar.makeKeyAndOrderFront(nil)
    }
    
    private func createAndPopulateView(_ display: Display) -> NSView
    {
        let view = NSView()
        addSpaceButtons(display, view)
        
        addLabel("| \(createDateTime())", display, view)
        addLabel("\(Yabai.queryBattery())%", display, view)
        
        return view
    }
    
    private func addLabel(_ string: String, _ display: Display, _ view: NSView)
    {
        let textfield = NSTextField(string: string)
        let x = findFreeSpace(display, view) - Double(textfield.frame.width)
        textfield.setFrameOrigin(NSPoint(x: x, y: 0))
        textfield.alignment = .center
        textfield.isBezeled = false
        textfield.drawsBackground = false
        textfield.isEditable = false
        textfield.isSelectable = false
        view.addSubview(textfield)
    }
    
    private func findFreeSpace(_ display: Display, _ view: NSView) -> Double
    {
        let filtered = view.subviews.filter { $0 is NSTextField }
        return filtered.isEmpty ?
            display.frame.w
        :
        filtered
            .map { Double($0.frame.origin.x) }
            .min()!
    }
    
    private func createDateTime() -> String
    {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return String(format: "%02d.%02d.%d %02d:%02d",
                      day, month, year, hour, minute)
    }
    
    private func addSpaceButtons(_ display: Display, _ view: NSView)
    {
        for (index, space) in display.spaces.enumerated() {
            let button = NSButton(
                frame: NSRect(x: 26 * index, y: 0, width: 26, height: 26))
            
            button.attributedTitle = NSMutableAttributedString(
                string: String(space),
                attributes: [.foregroundColor: NSColor.white])
            button.bezelStyle = .shadowlessSquare
            button.bezelColor = NSColor.white
            button.wantsLayer = true
            
            let isActive = spaces.filter { s in
                s.index == space && s.visible == 1
            }
            
            button.layer?.backgroundColor = isActive.isEmpty ?
                NSColor.init(
                    red: 72/255,
                    green: 78/255,
                    blue: 80/255,
                    alpha: 1).cgColor
                :
                NSColor.init(
                    red: 18/255,
                    green: 62/255,
                    blue: 96/255,
                    alpha: 1).cgColor
                
            button.action = #selector(changeSpace(_:))
            view.addSubview(button)
        }
    }
}


