import AppKit

class Yabai
{
    static func changeSpace(_ space: String)
    {
        sh("yabai -m space --focus \(space)")
    }
    
    static func querySpaces() -> [Space]
    {
        return try! JSONDecoder().decode(
            [Space].self,
            from: sh("yabai -m query --spaces"))
    }
    
    static func queryDisplays() -> [Display]
    {
        return try! JSONDecoder().decode(
            [Display].self,
            from: sh("yabai -m query --displays"))
    }

    @discardableResult
    private static func sh(_ command: String) -> Data
    {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["--login", "-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe
            .fileHandleForReading
            .readDataToEndOfFile()
        let output: String = NSString(
            data: data,
            encoding: String.Encoding.utf8.rawValue)! as String
        return output.data(using: .utf8)!
    }
}
