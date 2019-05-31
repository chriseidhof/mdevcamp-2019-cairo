import Cairo
import Foundation

func svg(size: CGSize, draw: (Context) -> ()) throws -> Data {
    let svgSurface = try SVGSurface(size: size)
    let context = try Context(svgSurface)
    draw(context)
    svgSurface.finish()
    return svgSurface.data
}

let filename = "/Users/chris/Desktop/out.svg"
let data = try svg(size: CGSize(width: 800, height: 600)) { context in
    context.setSource(color: .red)
    context.rectangle(CGRect(x: 0, y: 0, width: 200, height: 50))
    context.fill()
}
try data.write(to: URL(fileURLWithPath: filename))
