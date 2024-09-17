//
//  BitDataReader.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Foundation

class BitDataReader {
	enum ReadError: Error {
		case outOfBounds
		case cannotReadMoreThan16Bits
	}

	let data: Data

	private var readBitCount: UInt = 0

	init(_ data: Data) {
		self.data = data
	}

	func read(_ bitCount: UInt8) throws -> UInt16 {
		guard bitCount <= 16 else {
			throw ReadError.cannotReadMoreThan16Bits
		}

		var value: UInt16 = 0
		var bitToReadCount = bitCount
		repeat {
			let currentIndex = readBitCount + UInt(bitCount - bitToReadCount)
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

		readBitCount += UInt(bitCount)

		return value
	}
}
