local Class = require "amaze.leanclass"

local BitField = Class "BitField"

local function maskTest(nBit1, nBit2) return 0 ~= bit.band(nBit1, nBit2) end

function BitField:initialize(nField)
    self.nBitField = nField
end

function BitField:setBit(nBit)
    self.nBitField = bit.bor(self.nBitField, nBit)
end

function BitField:unsetBit(nBit)
    self.nBitField = bit.band(self.nBitField, bit.bnot(nBit))
end

function BitField:isSet(nBit)
    return maskTest(self.nBitField, nBit)
end

function BitField:getBit(nBit)
    return bit.band(self.nBitField, nBit)
end

function BitField:getBits()
    return self.nBitField
end

return BitField
