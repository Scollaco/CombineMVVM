import Foundation
import CoreGraphics

protocol Primitive {
    var type: Type { get }
}

indirect enum Type {
    case bool
    case int
    case int8
    case int16
    case int32
    case int64
    case uint
    case uint8
    case uint16
    case uint32
    case uint64
    case double
    case float
    case float80
    case cgFloat
    case string
    case date
    case wrapped(Any, Type)
}

extension Bool: Primitive {
    var type: Type { .bool }
}

extension Int: Primitive {
    var type: Type { .int }
}

extension Int8: Primitive {
    var type: Type { .int8 }
}

extension Int16: Primitive {
    var type: Type { .int16 }
}

extension Int32: Primitive {
    var type: Type { .int32 }
}

extension Int64: Primitive {
    var type: Type { .int64 }
}

extension UInt: Primitive {
    var type: Type { .uint }
}

extension UInt8: Primitive {
    var type: Type { .uint8 }
}

extension UInt16: Primitive {
    var type: Type { .uint16 }
}

extension UInt32: Primitive {
    var type: Type { .uint32 }
}

extension UInt64: Primitive {
    var type: Type { .uint64 }
}

extension Double: Primitive {
    var type: Type { .double }
}

extension Float: Primitive {
    var type: Type { .float }
}

extension Float80: Primitive {
    var type: Type { .float80 }
}

extension CGFloat: Primitive {
    var type: Type { .cgFloat }
}

extension String: Primitive {
    var type: Type { .string }
}

extension Date: Primitive {
    var type: Type { .date }
}

extension Primitive where Self: RawRepresentable, RawValue == Int {
    var type: Type { .wrapped(rawValue, .int) }
}

extension Primitive where Self: RawRepresentable, RawValue == Int8 {
    var type: Type { .wrapped(rawValue, .int8) }
}

extension Primitive where Self: RawRepresentable, RawValue == Int16 {
    var type: Type { .wrapped(rawValue, .int16) }
}

extension Primitive where Self: RawRepresentable, RawValue == Int32 {
    var type: Type { .wrapped(rawValue, .int32) }
}

extension Primitive where Self: RawRepresentable, RawValue == Int64 {
    var type: Type { .wrapped(rawValue, .int64) }
}

extension Primitive where Self: RawRepresentable, RawValue == UInt {
    var type: Type { .wrapped(rawValue, .uint) }
}

extension Primitive where Self: RawRepresentable, RawValue == UInt8 {
    var type: Type { .wrapped(rawValue, .uint8) }
}

extension Primitive where Self: RawRepresentable, RawValue == UInt16 {
    var type: Type { .wrapped(rawValue, .uint16) }
}

extension Primitive where Self: RawRepresentable, RawValue == UInt32 {
    var type: Type { .wrapped(rawValue, .uint32) }
}

extension Primitive where Self: RawRepresentable, RawValue == UInt64 {
    var type: Type { .wrapped(rawValue, .uint64) }
}

extension Primitive where Self: RawRepresentable, RawValue == Double {
    var type: Type { .wrapped(rawValue, .double) }
}

extension Primitive where Self: RawRepresentable, RawValue == Float {
    var type: Type { .wrapped(rawValue, .float) }
}

extension Primitive where Self: RawRepresentable, RawValue == Float80 {
    var type: Type { .wrapped(rawValue, .float80) }
}

extension Primitive where Self: RawRepresentable, RawValue == CGFloat {
    var type: Type { .wrapped(rawValue, .cgFloat) }
}

extension Primitive where Self: RawRepresentable, RawValue == String {
    var type: Type { .wrapped(rawValue, .string) }
}
