# RTL Modules Overview

The following Verilog files implement the sorting algorithm using a modular design:

| File Name         | Description                                               |
|-------------------|-----------------------------------------------------------|
| `ControllerFSM.v` | FSM that controls the sorting flow.      |
| `Datapath.v`      | Datapath for processing(comparisons and swaps)   |
| `Sort.v`          | Top-level module    |

## Parameters:
 N: Data Width
 L: Address Width
 K: Length of Array
