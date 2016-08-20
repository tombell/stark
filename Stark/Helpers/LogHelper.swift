import Foundation

public class LogHelper {
    public static func log(message: String) {
        NSLog("%@", message)

        let dir = NSURL(fileURLWithPath: NSHomeDirectory())
        let file = dir.URLByAppendingPathComponent(".stark.log")

        let formatter = NSDateFormatter()
        formatter.dateFormat = "[yyyy-MM-dd HH:mm:ss]"

        let log = String(format: "%@ %@", formatter.stringFromDate(NSDate()), message)

        _ = try? stringAppendLineToURL(log, fileURL: file!)
    }

    private static func stringAppendLineToURL(message: String, fileURL: NSURL) throws {
        try stringAppendToURL(message.stringByAppendingString("\n"), fileURL: fileURL)
    }

    private static func stringAppendToURL(message: String, fileURL: NSURL) throws {
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)!
        try dataAppendToURL(data, fileURL: fileURL)
    }

    private static func dataAppendToURL(data: NSData, fileURL: NSURL) throws {
        if let fileHandle = try? NSFileHandle(forWritingToURL: fileURL) {
            defer {
                fileHandle.closeFile()
            }

            fileHandle.seekToEndOfFile()
            fileHandle.writeData(data)
        } else {
            try data.writeToURL(fileURL, options: .DataWritingAtomic)
        }
    }
}
