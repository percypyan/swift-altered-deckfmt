//
//  BitData.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Foundation

class BitData {
	enum ReadError: Error {
		case outOfBounds
		case cannotReadMoreThan16Bits
	}

	private(set) var data: Data

	private var buffer: UInt8 = 0
	private var currentFreeBitCount: UInt8 = 8

	init(_ data: Data = Data()) {
		self.data = data
	}

	func append(_ value: UInt16, bitCount: UInt8) {
		let cleanedValue = cleanTwoBytesValue(value, bitCount: bitCount)
		var remainingBitCount = bitCount
		repeat {
			let writeCount = min(remainingBitCount, currentFreeBitCount)
			let rightShift = remainingBitCount - writeCount
			let leftShift = currentFreeBitCount - writeCount

			buffer += UInt8(UInt8(((cleanedValue >> rightShift) << leftShift) & 255))

			remainingBitCount -= writeCount
			currentFreeBitCount -= writeCount

			if currentFreeBitCount == 0 {
				data.append(buffer)
				buffer = 0
				currentFreeBitCount = 8
			}
		} while remainingBitCount > 0
	}

	func commitBuffer() {
		if currentFreeBitCount < 8 {
			data.append(buffer)
			buffer = 0
			currentFreeBitCount = 8
		}
	}

	func read(atBitIndex index: UInt, bitCount: UInt8) throws -> UInt16 {
		guard bitCount <= 16 else {
			throw ReadError.cannotReadMoreThan16Bits
		}

		var value: UInt16 = 0
		var bitToReadCount = bitCount
		repeat {
			let currentIndex = index + UInt(bitCount - bitToReadCount)
			let byteIndex = Int(currentIndex / 8)
			let bitIndex = UInt8(currentIndex % 8)

			guard byteIndex < data.count else {
				throw ReadError.outOfBounds
			}

			let byte = data[byteIndex]
			let partialValueBitCount = min(bitToReadCount, 8 - bitIndex)
			let partialValue = ((byte << bitIndex) >> bitIndex) >> (8 - bitIndex - partialValueBitCount)
			value = (value << partialValueBitCount) + UInt16(partialValue)

			bitToReadCount -= partialValueBitCount
		} while bitToReadCount > 0

		return value
	}
}

private func cleanTwoBytesValue(_ bytes: UInt16, bitCount: UInt8) -> UInt16 {
	let shift = 16 - max(bitCount, 16)
	return UInt16(UInt16(bytes << shift) >> shift)
}
