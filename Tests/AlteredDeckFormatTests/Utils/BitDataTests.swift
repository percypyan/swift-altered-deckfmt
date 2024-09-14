//
//  BitDataTests.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 14/09/2024.
//

import Testing
import Foundation
@testable import AlteredDeckFormat

@Test("Create empty BitData instance")
func createEmptyBitData() {
	#expect(BitData().data.isEmpty)
}

@Test("Create BitData from existing data")
func createBitDataFromExistingData() {
	let data = Data([1, 2, 3])
	#expect(BitData(data).data == data)
}

@Test("Append bits to BitData - simple")
func appendBitsToBitDataSimple() {
	let bitData = BitData()
	bitData.append(15, bitCount: 4)
	#expect(bitData.data.isEmpty)
	bitData.commitBuffer()
	#expect(bitData.data.first == 15 << 4)
}

@Test("Append bits to BitData - medium")
func appendBitsToBitDataMedium() {
	let bitData = BitData()
	bitData.append(15, bitCount: 4)
	bitData.append(1, bitCount: 6)
	bitData.append(7, bitCount: 3)
	bitData.commitBuffer()

	#expect(bitData.data.count == 2)
	#expect(bitData.data.first == 15 << 4)
	#expect(bitData.data.last == (1 << 6) + (7 << 3))
}

@Test("Append bits to BitData - hard")
func appendBitsToBitDataHard() {
	let bitData = BitData()
	bitData.append(15, bitCount: 4)
	bitData.append(1, bitCount: 6)
	bitData.append(7, bitCount: 3)
	bitData.append(320, bitCount: 16)
	bitData.commitBuffer()

	#expect(bitData.data.count == 4)
	#expect(bitData.data.first == 15 << 4)
	#expect(bitData.data[1] == 120)
	#expect(bitData.data[2] == 10)
	#expect(bitData.data[3] == 0)
}

@Test("Read bits to BitData")
func readBits() throws {
	let bitData = BitData(Data([0b0110_1101, 0b0100_0001, 0b1110_0100]))

	#expect(try bitData.read(atBitIndex: 2, bitCount: 2) == 0b10)
	#expect(try bitData.read(atBitIndex: 2, bitCount: 4) == 0b1011)
	#expect(try bitData.read(atBitIndex: 6, bitCount: 4) == 0b0101)
	#expect(try bitData.read(atBitIndex: 7, bitCount: 16) == 0b1010_0000_1111_0010)
}
