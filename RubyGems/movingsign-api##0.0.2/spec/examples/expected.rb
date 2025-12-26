# Contains the expected binary output for the examples given in the "MovingSign Communication Protocol V2.1" specification

EXAMPLE_A_EXPECTED = [
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x01,       # <SOH>
    0x46,       # Sender Address, 'FF'
    0x46,       # Sender Address, 'FF'
    0x30,       # Receiver Address, '03'
    0x33,       # Receiver Address, '03'
    0x02,       # <SOT> Start of Text
    0x41,       # Command 'A' - Write Text File
    0x41,       # Text File Name 'A'
    0x41,       # Text Display Mode 'A'
    0x32,       # Text Display Speed '2'
    0x32,       # Pause Seconds '2'
    0x37,       # Display Every Day '7F'
    0x46,       # Display Every Day '7F'
    0x30,       # Display Time Start '0100'
    0x31,       # Display Time Start '0100'
    0x30,       # Display Time Start '0100'
    0x30,       # Display Time Start '0100'
    0x31,       # Display Time End '1200'
    0x32,       # Display Time End '1200'
    0x30,       # Display Time End '1200'
    0x30,       # Display Time End '1200'
    0x30,       # No Use '000'
    0x30,       # No Use '000'
    0x30,       # No Use '000'
    0x31,       # Alight Left '1'
    0x48,       # Text Body: 'HELLO'
    0x45,       # Text Body: 'HELLO'
    0x4C,       # Text Body: 'HELLO'
    0x4C,       # Text Body: 'HELLO'
    0x4F,       # Text Body: 'HELLO'
    0x03,       # <ETX>
    0x30,       # Checksum '0562' - spec says '0564' but it is wrong
    0x35,       # Checksum '0562'
    0x36,       # Checksum '0562'
    0x32,       # Checksum '0562'
    0x04,       # <EOT>
]

EXAMPLE_C_EXPECTED = [
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x01,       # <SOH>
    0x46,       # Sender Address, 'FF'
    0x46,       # Sender Address, 'FF'
    0x32,       # Receiver Address, 34 dec, 22 hex
    0x32,       # Receiver Address, 34 dec, 22 hex
    0x02,       # <SOT> Start of Text
    0x57,       # Command 'W' - Control Command
    0x41,       # Sub Command 'A' - Write Clock Command
    0x32,       # Clock Data 200404021236235 - 2
    0x30,       # Clock Data 200404021236235 - 0
    0x30,       # Clock Data 200404021236235 - 0
    0x34,       # Clock Data 200404021236235 - 4
    0x30,       # Clock Data 200404021236235 - 0
    0x34,       # Clock Data 200404021236235 - 4
    0x30,       # Clock Data 200404021236235 - 0
    0x32,       # Clock Data 200404021236235 - 2
    0x31,       # Clock Data 200404021236235 - 1
    0x32,       # Clock Data 200404021236235 - 2
    0x33,       # Clock Data 200404021236235 - 3
    0x36,       # Clock Data 200404021236235 - 6
    0x32,       # Clock Data 200404021236235 - 2
    0x33,       # Clock Data 200404021236235 - 3
    0x35,       # Clock Data 200404021236235 - 5
    0x03,       # <EOT>
    0x30,       # Checksum '038F'
    0x33,       # Checksum '038F'
    0x38,       # Checksum '038F'
    0x46,       # Checksum '038F'
    0x04,       # <EOT>
]

EXAMPLE_D_EXPECTED = [
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x01,       # <SOH>
    0x46,       # Sender Address, 'FF'
    0x46,       # Sender Address, 'FF'
    0x32,       # Receiver Address, 34 dec, 22 hex
    0x32,       # Receiver Address, 34 dec, 22 hex
    0x02,       # <SOT> Start of Text
    0x57,       # Command 'W' - Control Command
    0x42,       # Sub Command 'B' - Software Reset
    0x03,       # <EOT>
    0x30,       # Checksum '009E'
    0x30,       # Checksum '009E'
    0x39,       # Checksum '009E'
    0x45,       # Checksum '009E'
    0x04,       # <EOT>
]

EXAMPLE_K_EXPECTED = [
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x00,       # <NUL> x 5
    0x01,       # <SOH>
    0x46,       # Sender Address, 'FF'
    0x46,       # Sender Address, 'FF'
    0x31,       # Receiver Address, 16 dec, 10 hex
    0x30,       # Receiver Address, 16 dec, 10 hex
    0x02,       # <SOT> Start of Text
    0x57,       # Command 'W' - Control Command
    0x4C,       # Sub Command 'L' - Software Reset
    0x03,       # <EOT>
    0x30,       # Checksum '00A8'
    0x30,       # Checksum '00A8'
    0x41,       # Checksum '00A8'
    0x38,       # Checksum '00A8'
    0x04,       # <EOT>
]

# Calc checksum
sum = EXAMPLE_K_EXPECTED[10..-6].reduce(:+)
puts ('%04x' % sum).upcase