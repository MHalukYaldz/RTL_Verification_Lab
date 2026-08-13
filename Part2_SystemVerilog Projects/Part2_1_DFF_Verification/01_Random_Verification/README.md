# Random DFF Verification

This study verifies the basic behavior of a D flip-flop using randomized input stimulus.

A SystemVerilog verification environment is used to generate input transactions, drive the DUT, monitor the output, and compare the observed value with the expected input value.

## Verification Scope

* Randomized `din` generation
* DFF operation on the rising edge of the clock
* Reset behavior
* Input/output data comparison
* Scoreboard-based result checking
* Transaction synchronization between verification components

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores DFF input and output data
* **Generator** — Generates randomized input transactions
* **Driver** — Applies generated input data to the DUT
* **Monitor** — Captures the DFF output
* **Scoreboard** — Compares the observed output with the reference input
* **Environment** — Connects and controls the verification components

SystemVerilog mailboxes are used for transaction communication, while events are used for synchronization between the generator and scoreboard.

## Simulation Waveform

The waveform below shows the DFF response during randomized input stimulus. After reset is released, the output follows the input on the rising edge of the clock.

<img width="1835" height="100" alt="01_Random_Verification_dff_random_verification_waveform" src="https://github.com/user-attachments/assets/090dd053-86e1-44b4-8c3c-4ca7ed7f8a46" />
