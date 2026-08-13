# Part2 – SystemVerilog Verification Projects

Class-based SystemVerilog verification environments developed for digital designs and communication interfaces.

## Projects

| Project | DUT | Verification Focus |
|---|---|---|
| Part2_1 | D Flip-Flop | Data transfer, reset and unknown input behavior |
| Part2_2 | FIFO | Read/write, full/empty and data ordering |
| Part2_3 | SPI | Master/Slave communication and serial data verification |
| Part2_4 | UART | TX/RX, serial data, parity and frame checks |

## Testbench Architecture

`Transaction → Generator → Driver → DUT → Monitor → Scoreboard`

## Techniques Used

- Constrained random stimulus
- Mailbox communication
- Event synchronization
- Virtual interfaces
- Self-checking scoreboards
