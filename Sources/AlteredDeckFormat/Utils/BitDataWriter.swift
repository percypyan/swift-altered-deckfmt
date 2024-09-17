//
//  BitDataWriter.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Foundation

class BitDataWriter {
	private(set) var data = Data()

	private var buffer: UInt8 = 0
	private var currentFreeBitCount: UInt8 = 8

	func append(_ value: UInt16, bitCount: UInt8) {
		let cleanedValue = cleanTwoBytesValue(value, bitCount: bitCount)
		var remainingBitCount = bitCount
		repeat {
			let writeCount = min(remainingBitCount, currentFreeBitCount)
			let rightShift = remainingBitCount - writeCount
			let leftShift = currentFreeBitCount - writeCount

			buffer += UInt8(((cleanedValue >> rightShift) << leftShift) & UInt16(UInt8.max))

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
}

private func cleanTwoBytesValue(_ bytes: UInt16, bitCount: UInt8) -> UInt16 {
	let shift = 16 - max(bitCount, 16)
	return bytes & (UInt16.max >> shift)
}
