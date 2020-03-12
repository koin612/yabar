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
            from: shd("yabai -m query --spaces"))
    }
    
    static func queryDisplays() -> [Display]
    {
        return try! JSONDecoder().decode(
            [Display].self,
            from: shd("yabai -m query --displays"))
    }

    static func queryBattery() -> String
    {
        // consider bridging-headers for IOPowerSources.h
        return sh("pmset -g batt | grep -Eo '\\d+%' | cut -d% -f1")
    }
    
    private static func shd(_ command: String) -> Data
    {
        return sh(command).data(using: .utf8)!
    }
    
    @discardableResult
    private static func sh(_ command: String) -> String
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
        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
