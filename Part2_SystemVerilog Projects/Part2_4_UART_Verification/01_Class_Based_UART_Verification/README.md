# Class-Based UART Verification

This project demonstrates a **class-based SystemVerilog verification environment** for a UART RTL design.

The UART transmitter and receiver are verified independently using randomized transactions and reusable verification components.

## UART RTL Design

The RTL contains separate UART transmitter (`uarttx`) and receiver (`uartrx`) modules connected through the `uart_top` module.

* **TX path:** Parallel data is serialized onto the `tx` line.
* **RX path:** Serial data applied to the `rx` line is converted back into parallel data.
* TX and RX are tested independently in this verification environment.
* No TX-to-RX loopback connection is used.

<img width="811" height="221" alt="UART_RTL_Block_Diagram_drawio" src="https://github.com/user-attachments/assets/b418f13b-db51-4942-a4d3-a5f3cc48b37b" />


## Verification Architecture

The testbench is organized using basic class-based verification components:

* **Transaction** – Holds randomized operation and data information.
* **Generator** – Creates randomized transactions.
* **Driver** – Applies generated transactions to the UART interface.
* **Monitor** – Observes UART TX and RX behavior.
* **Scoreboard** – Compares expected and monitored data.
* **Environment** – Connects and controls the verification components.
* **Mailbox** – Transfers transactions and data between components.
* **Events** – Synchronize generator, driver, and scoreboard operations.

### TX Verification Flow

```text
Generator
   |
   v
Driver
   |
   v
UART TX
   |
   v
Monitor
   |
   v
Scoreboard
```

For a TX transaction, the randomized parallel data is applied to `dintx`. The UART transmitter serializes the data on the `tx` line. The monitor reconstructs the transmitted byte and the scoreboard compares it with the expected value.

### RX Verification Flow

```text
Generator
   |
   v
Driver
   |
   v
UART RX
   |
   v
Monitor
   |
   v
Scoreboard
```

For an RX transaction, the driver serializes the randomized transaction data and applies it to the `rx` line in UART format. The receiver reconstructs the byte on `doutrx`, which is then captured by the monitor and checked by the scoreboard.

## Simulation Results

Five randomized UART transactions were executed during the simulation.

Example results:

```text
[GEN]: Oper : write Din : 106
[DRV]: Data Sent : 106
[MON]: DATA SEND on UART TX 106
[SCO]: DRV : 106 MON : 106
DATA MATCHED

[GEN]: Oper : read Din : 102
[DRV]: Data Sent to UART RX : 102
[MON]: DATA RCVD RX 102
[SCO]: DRV : 102 MON : 102
DATA MATCHED
```

All generated data values matched the values captured by the monitor.

<img width="322" height="611" alt="UART_Class_Based_Verification_Console" src="https://github.com/user-attachments/assets/fb57b530-7325-4239-9239-d467536d06ba" />


## Waveform

The waveform shows both TX and RX verification operations.

For TX operations, `dintx` is serialized onto the `tx` signal and `donetx` indicates completion.

For RX operations, serial data is driven onto the `rx` signal. The receiver reconstructs the data on `doutrx`, and `donerx` indicates that reception is complete.

<img width="1837" height="239" alt="UART_Class_Based_Verification_Waveform" src="https://github.com/user-attachments/assets/5177184b-d781-4f11-a068-56caf603261a" />


## Configuration

```text
System Clock : 1 MHz
Baud Rate    : 9600
Data Width   : 8 bits
```
