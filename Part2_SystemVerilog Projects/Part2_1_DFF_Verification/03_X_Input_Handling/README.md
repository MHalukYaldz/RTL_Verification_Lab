# DFF X Input Handling

This study extends the DFF verification environment by defining a specific response for an unknown (`X`) input.

When `din` contains an unknown value, the DUT forces `dout` to `0`. The scoreboard checks whether the observed output matches this expected behavior.

## Verification Scope

* Unknown (`X`) input handling
* Controlled output response for an unknown input
* Expected `X → 0` behavior
* Reset behavior
* Scoreboard-based result checking

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores DFF input and output data
* **Generator** — Provides the input transactions
* **Driver** — Applies the transaction input to the DUT
* **Monitor** — Captures the resulting DFF output
* **Scoreboard** — Checks the expected output behavior
* **Environment** — Connects and coordinates the verification components

This study demonstrates how the verification environment can be adapted to test a defined response for unknown input states.

## Simulation Waveform

The waveform below shows the modified DFF behavior for an unknown (`X`) input. When `din` is unknown, the DUT forces `dout` to `0`, and the scoreboard checks this behavior.

<img width="1837" height="101" alt="03_X_Input_Handling_dff_x_input_handling_waveform" src="https://github.com/user-attachments/assets/a8618cf2-3a01-4d04-9693-22c52f9e2bc5" />
