import AppKit

public let AppObserverWindowKey = "ObserverWindowKey"

public class AppObserver {
    private static let notifications = [
        NSAccessibilityWindowCreatedNotification,
        NSAccessibilityUIElementDestroyedNotification,
        NSAccessibilityFocusedWindowChangedNotification,
        NSAccessibilityWindowMovedNotification,
        NSAccessibilityWindowResizedNotification,
        NSAccessibilityWindowMiniaturizedNotification,
        NSAccessibilityWindowDeminiaturizedNotification,
    ]

    private var element: AXUIElementRef
    private var observer: AXObserverRef

    init(app: NSRunningApplication) {
        self.element = AXUIElementCreateApplication(app.processIdentifier).takeRetainedValue()

        let callback: AXObserverCallback = { _, element, notification, _ in
            let window = Window(element: element)

            NSNotificationCenter
                .defaultCenter()
                .postNotificationName(notification as String, object: nil, userInfo: [AppObserverWindowKey: window])
        }

        var observer: AXObserverRef? = nil
        AXObserverCreate(app.processIdentifier, callback, &observer)
        self.observer = observer!

        setup()
    }

    deinit {
        for notification in AppObserver.notifications {
            removeNotification(notification)
        }
    }

    public func addNotification(notification: String) {
        AXObserverAddNotification(self.observer, self.element, notification, nil)
    }

    public func removeNotification(notification: String) {
        AXObserverRemoveNotification(self.observer, self.element, notification)
    }

    private func setup() {
        CFRunLoopAddSource(
            CFRunLoopGetCurrent(),
            AXObserverGetRunLoopSource(self.observer).takeRetainedValue(),
            kCFRunLoopDefaultMode
        )

        for notification in AppObserver.notifications {
            addNotification(notification)
        }
    }
}