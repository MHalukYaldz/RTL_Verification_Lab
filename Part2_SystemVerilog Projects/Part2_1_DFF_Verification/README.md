# D Flip-Flop Verification

## Verification Scope

- Data input/output behavior
- Reset operation
- Random stimulus
- Expected vs. actual output comparison
- Unknown (`X`) input behavior

## Components

`Generator → Driver → DFF → Monitor → Scoreboard`

## SystemVerilog Features

- Transaction class
- Mailboxes
- Events
- Virtual interface
- Self-checking scoreboard


## Simulation Waveform

The waveform below shows the DFF response during randomized input stimulus and reset operation.


<img width="1835" height="100" alt="Waveform" src="https://github.com/user-attachments/assets/f78a1853-efff-4f6f-9303-de760c0f278e" />
