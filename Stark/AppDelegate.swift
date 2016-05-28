import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

    let config = Config()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        AccessibilityHelper.askForAccessibilityIfNeeded()

        setupStatusItem()

        config.load()

        NSNotificationCenter
            .defaultCenter()
            .postNotificationName(StarkStartNotification, object: self)
    }

    func setupStatusItem() {
        let image = NSImage(named: "StatusItemIcon")
        image?.template = true

        statusItem.highlightMode = true
        statusItem.image = image

        let loginMenuItem = NSMenuItem(title: "Run at login", action: #selector(AppDelegate.toggleRunAtLogin(_:)), keyEquivalent: "")

        let menu = NSMenu()
        menu.addItemWithTitle("About", action: #selector(AppDelegate.about(_:)), keyEquivalent: "")
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItemWithTitle("Edit config file", action: #selector(AppDelegate.editConfig(_:)), keyEquivalent: "")
        menu.addItemWithTitle("Reload config file", action: #selector(AppDelegate.reloadConfig(_:)), keyEquivalent: "")
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(loginMenuItem)
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItemWithTitle("Quit Stark", action: #selector(AppDelegate.quit(_:)), keyEquivalent: "")

        if LaunchAgentHelper.enabled() {
            loginMenuItem.state = NSOnState
        } else {
            loginMenuItem.state = NSOffState
        }

        statusItem.menu = menu
    }

    func editConfig(sender: AnyObject?) {
        config.edit()

    }

    func reloadConfig(sender: AnyObject?) {
        config.load()
    }

    func toggleRunAtLogin(sender: NSMenuItem) {
        if sender.state == NSOnState {
            LaunchAgentHelper.remove()
            sender.state = NSOffState
        } else {
            LaunchAgentHelper.add()
            sender.state = NSOnState
        }
    }

    func about(sender: AnyObject?) {

    }

    func quit(sender: AnyObject?) {
        NSApp.terminate(nil)
    }
}