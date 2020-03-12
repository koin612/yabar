import Foundation

struct Frame: Decodable
{
    let x, y, w, h: Double
}

struct Display: Decodable
{
    let spaces: [Int]
    let frame: Frame
}
