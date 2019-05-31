import CCairo
import Foundation

public struct CairoError: Error {
    let status: cairo_status_t
    
    static func check(_ status: cairo_status_t) throws {
        guard status == CAIRO_STATUS_SUCCESS else {
            throw CairoError(status: status)
        }
    }
}

final class Box<A> {
    var value: A
    init(_ value: A) { self.value = value }
}

public class Surface  {
    let pointer: OpaquePointer
    init(_ pointer: OpaquePointer) throws {
        self.pointer = pointer
        try CairoError.check(cairo_surface_status(pointer))
    }
    
    deinit {
        cairo_surface_destroy(pointer)
    }
    
    public func finish() {
        cairo_surface_finish(pointer)
    }

}

final public class ImageSurface: Surface {
    public init(size: CGSize) throws {
        try super.init(cairo_image_surface_create(CAIRO_FORMAT_ARGB32, Int32(size.width), Int32(size.height)))
    }
    
}

final public class SVGSurface: Surface {
    var _data = Box(Data())
    public init(size: CGSize) throws {
        let p = cairo_svg_surface_create_for_stream({ (rawPointer, bytes, length) -> cairo_status_t in
            let boxedData = Unmanaged<Box<Data>>.fromOpaque(rawPointer!).takeUnretainedValue()
            boxedData.value.append(bytes!, count: Int(length))
            return CAIRO_STATUS_SUCCESS
            
        }, Unmanaged<Box<Data>>.passUnretained(_data).toOpaque(), Double(size.width), Double(size.height))
        try super.init(p!)
    }
    
    public var data: Data {
        return _data.value
    }
}

public struct Color {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    public static let red: Color = Color(red: 1, green: 0, blue: 0, alpha: 1)
    public static let green: Color = Color(red: 0, green: 1, blue: 0, alpha: 1)
}

public final class Context {
    let pointer: OpaquePointer
    public init(_ surface: Surface) throws {
        pointer = cairo_create(surface.pointer)!
        try CairoError.check(cairo_status(pointer))
    }
    
    deinit {
        cairo_destroy(pointer)
    }
    
    public func setSource(color: Color) {
        cairo_set_source_rgba(pointer, color.red, color.green, color.blue, color.alpha)
    }
    
    public func rectangle(_ rect: CGRect) {
        cairo_rectangle(pointer, Double(rect.minX), Double(rect.minY), Double(rect.width), Double(rect.height))
    }
    
    public func fill() {
        cairo_fill(pointer)
    }
}
