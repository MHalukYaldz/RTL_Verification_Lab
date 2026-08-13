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

<img width="1840" height="101" alt="Waveform" src="https://github.com/user-attachments/assets/7c4e3aa9-67f5-4678-8b6b-bcaacdb9fa46" />
