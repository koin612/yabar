import Foundation

struct Frame: Decodable
{
    let x, y, w, h: Float
}

struct Display: Decodable
{
    let spaces: [Int]
    let frame: Frame
}
