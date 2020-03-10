import AppKit

class YabarController : NSObject, NSApplicationDelegate
{
    let displays: [Display]
    let spaces: [Space]
    
    init(_ displays: [Display])
    {
        self.displays = displays
        self.spaces = Yabai.querySpaces()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        displays.forEach { display in
            createStatusBar(display)
        }
    }
    
    func applicationDidUpdate(_ notification: Notification)
    {
    }
    
    @objc private func changeSpace(_ sender: NSButton)
    {
        Yabai.changeSpace(sender.title)
    }
    
    private func createStatusBar(_ display: Display)
    {
        let bar = NSWindow.init(
            contentRect: NSMakeRect(
                CGFloat(display.frame.x),
                CGFloat(display.frame.y),
                CGFloat(display.frame.w),
                26),
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
            .transient,
            .ignoresCycle]
        bar.isOpaque = false
//        bar.level = .floating
        bar.makeKeyAndOrderFront(nil)
    }
    
    private func createDateTime()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        print("\(hour):\(minute)")

    }
    
    private func createAndPopulateView(_ display: Display) -> NSView
    {
        let view = NSView()
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
        return view
    }
}

