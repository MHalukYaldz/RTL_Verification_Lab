# DFF X Input Test

This study examines the behavior of a D flip-flop when an unknown (`X`) value is applied to its input.

Instead of randomized binary input data, the generator explicitly applies an `X` value to `din`. The resulting DUT behavior is observed through the monitor and simulation waveform.

## Verification Scope

* Application of an unknown (`X`) input
* DFF response to four-state logic
* Propagation of the unknown value to the output
* Reset behavior
* Observation of `din` and `dout` during simulation
* Use of `logic` for four-state signal representation

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores four-state DFF input and output values
* **Generator** — Applies `1'bx` as the input stimulus
* **Driver** — Drives the unknown input value to the DUT
* **Monitor** — Observes and captures the resulting output
* **Scoreboard** — Receives the reference and monitored transactions
* **Environment** — Connects and coordinates the verification components

This test extends the basic DFF verification by introducing an unknown input value and observing its propagation through the DUT.

## Simulation Waveform

The waveform below shows the behavior of the DFF when an unknown (`X`) value is applied to the input. The unknown value propagates to the output on the rising edge of the clock.

<img width="1835" height="99" alt="02_X_Input_Test_dff_x_input_test_waveform" src="https://github.com/user-attachments/assets/0f0d7167-d88d-487f-93f0-788d58017642" />
