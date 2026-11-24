
# Vending Machine Controller using Verilog HDL

<p align="center">
  <b>RTL Design | Finite State Machine | Functional Verification</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Simulation-Synopsys%20VCS-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Debugging-Synopsys%20Verdi-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Waveform-FSDB-purple?style=for-the-badge" />
</p>

---

## 1. Project Overview

This project presents the RTL design and functional verification of a **Vending Machine Controller** using Verilog Hardware Description Language (HDL).

The vending machine controller is designed using a **Moore Finite State Machine (FSM)** architecture to control product dispensing based on the amount of money inserted by the user.

The design accepts two types of coin inputs:

- 5-unit coin (`coin5`)
- 10-unit coin (`coin10`)

The vending machine dispenses a product when the accumulated amount reaches 15 units or 20 units.

- **15 units:** Product is dispensed without returning change.
- **20 units:** Product is dispensed and change output is activated.

The RTL implementation is simulated using **Synopsys VCS**, while waveform visualization and signal-level debugging are performed using **Synopsys Verdi**.

---

## 2. Design Specifications

| Parameter | Description |
|---|---|
| Design Name | Vending Machine Controller |
| Design Type | Sequential Logic |
| Architecture | Moore Finite State Machine |
| Coin Input 1 | 5-unit coin |
| Coin Input 2 | 10-unit coin |
| Product Price | 15 units |
| Maximum Accumulated Amount | 20 units |
| Output 1 | Dispense |
| Output 2 | Change |
| Reset | Active-high asynchronous reset |
| Clock | Positive-edge triggered |
| HDL | Verilog |
| RTL Simulator | Synopsys VCS |
| Waveform Viewer | Synopsys Verdi |
| Waveform Format | FSDB |

---

## 3. Design Methodology

The vending machine controller is implemented using a Finite State Machine (FSM).

The FSM tracks the accumulated amount of money inserted by the user and generates the appropriate outputs depending on the current state.

### 3.1 State Definition

Five states are used to represent the accumulated amount.

| State | Binary Encoding | Accumulated Amount |
|---|:---:|---:|
| S0 | 000 | 0 |
| S5 | 001 | 5 |
| S10 | 010 | 10 |
| S15 | 011 | 15 |
| S20 | 100 | 20 |

The initial state of the vending machine is S0.

### 3.2 State Transition Logic

The state transitions are controlled by the coin inputs.

| Current State | No Coin | Coin5 = 1 | Coin10 = 1 |
|---|---|---|---|
| S0 | S0 | S5 | S10 |
| S5 | S5 | S10 | S15 |
| S10 | S10 | S15 | S20 |
| S15 | S0 | S0 | S0 |
| S20 | S0 | S0 | S0 |

The following conditions are implemented:

- When a 5-unit coin is inserted, the accumulated amount increases by 5 units.
- When a 10-unit coin is inserted, the accumulated amount increases by 10 units.
- When the accumulated amount reaches 15 units, the machine dispenses the product.
- When the accumulated amount reaches 20 units, the machine dispenses the product and activates change.
- After reaching S15 or S20, the machine returns to the initial state S0 on the next active clock edge.

**Note:** If both coin inputs are HIGH simultaneously, the RTL gives priority to `coin5` because of the `if-else if` structure.

### 3.3 Moore FSM State Diagram and Transition Table

The following diagram represents the Moore FSM architecture, state transitions, and corresponding output conditions of the vending machine controller.

![Moore FSM State Diagram and State Transition Table](screenshots/moore_fsm_state_diagram.jpeg)

**Output Conditions:**

| Current State | Dispense | Change |
|---|:---:|:---:|
| S0 | 0 | 0 |
| S5 | 0 | 0 |
| S10 | 0 | 0 |
| S15 | 1 | 0 |
| S20 | 1 | 1 |

- **S15:** Successful product dispensing without change.
- **S20:** Successful product dispensing with change.

Both S15 and S20 return to S0 unconditionally on the next positive clock edge.

### 3.4 Output Generation

The vending machine uses Moore FSM output logic.

The outputs depend only on the current FSM state.

**Boolean Conditions:**

- `dispense = 1` when the current state is S15 or S20.
- `change = 1` when the current state is S20.

Therefore, the machine generates the appropriate dispensing and change signals based on the accumulated amount.

---

## 4. RTL Module Architecture

The project consists of the following Verilog modules:

| Module | Functionality |
|---|---|
| `vending_machine` | Implements the vending machine FSM and output logic |
| `vending_machine_tb` | Testbench for functional verification |

### 4.1 Vending Machine Controller

The main RTL module implements the following operations:

**1. State Register**

- Stores the current FSM state.
- Updates on every positive edge of the clock.
- Uses an active-high asynchronous reset.
- Initializes the FSM to S0.

**2. Next State Logic**

- Determines the next state based on the current state and coin inputs.
- Implements the coin accumulation functionality.
- Uses combinational logic with a `case` statement.

**3. Output Logic**

- Generates `dispense` and `change` signals.
- Uses the current FSM state to determine the outputs.
- Implements Moore FSM output behavior.

---

## 5. Repository Structure

```text
vending-machine-controller/
│
├── vending_machine.v
│   └── RTL source code (FSM implementation)
│
├── vending_machine_tb.v
│   └── Functional verification testbench
│
├── screenshots/
│   ├── moore_fsm_state_diagram.png
│   └── verdi_waveform.png
│
├── README.md
│
└── .gitignore
```

Generated simulation files such as FSDB databases, VCD files, compiled executables, and intermediate simulation directories can be maintained locally rather than committed to GitHub.

---

## 6. Functional Verification

A Verilog testbench is developed to verify the functional behavior of the vending machine controller.

The testbench generates a clock signal with a 10 ns period and applies different coin combinations to verify product dispensing and change generation.

The simulation uses `$monitor` to display the input and output signal values during execution.

### 6.1 Test Scenarios

| Test Case | Coin Sequence | Total Amount | Expected Dispense | Expected Change |
|:---:|---|---:|:---:|:---:|
| TC1 | 5 + 10 | 15 | 1 | 0 |
| TC2 | 10 + 10 | 20 | 1 | 1 |
| TC3 | 5 | 5 | 0 | 0 |

### 6.2 Test Case Description

**TC1: Product Dispensing Without Change**

- Insert a 5-unit coin.
- Insert a 10-unit coin.
- Total accumulated amount = 15 units.
- Expected output: `dispense = 1`, `change = 0`.

**TC2: Product Dispensing With Change**

- Insert a 10-unit coin.
- Insert another 10-unit coin.
- Total accumulated amount = 20 units.
- Expected output: `dispense = 1`, `change = 1`.

**TC3: Insufficient Amount**

- Insert a 5-unit coin.
- Total accumulated amount = 5 units.
- Expected output: `dispense = 0`, `change = 0`.

### 6.3 Expected Simulation Behavior

```text
TC1: Coin5 = 1, Coin10 = 1
     Total = 15
     Dispense = 1
     Change = 0

TC2: Coin10 = 1, Coin10 = 1
     Total = 20
     Dispense = 1
     Change = 1

TC3: Coin5 = 1
     Total = 5
     Dispense = 0
     Change = 0
```

The dispense and change outputs are activated for the corresponding FSM states and remain active until the next positive clock edge moves the FSM back to S0.

---

## 7. Simulation Environment

The design is simulated using Synopsys VCS, and waveform analysis is performed using Synopsys Verdi.

### 7.1 Simulation Workflow

```text
       Verilog RTL Design
               |
               v
        Verilog Testbench
               |
               v
         Synopsys VCS
               |
               v
         RTL Simulation
               |
               v
         FSDB Database
               |
               v
        Synopsys Verdi
               |
               v
        Waveform Analysis
```

### 7.2 VCS Compilation

Compile the RTL source and testbench using:

```bash
vcs -full64 -debug_access+all \
vending_machine.v \
vending_machine_tb.v \
-o simv
```

Ensure that the Verdi FSDB PLI integration is configured correctly in the VCS environment.

### 7.3 Execute Simulation

```bash
./simv
```

The simulation executes the testbench and displays the signal transitions using the `$monitor` system task.

### 7.4 FSDB Waveform Generation

The following commands are included in the testbench to generate an FSDB waveform:

```verilog
initial begin
    $fsdbDumpfile("vending_machine.fsdb");
    $fsdbDumpvars(0, vending_machine_tb);
end
```

The FSDB PLI support must be enabled during VCS compilation.

### 7.5 Open FSDB in Synopsys Verdi

Use the following command to open the generated FSDB waveform:

```bash
verdi -ssf vending_machine.fsdb &
```

The waveform database can be explored using the Verdi waveform viewer.

---

## 8. Waveform Analysis

Synopsys Verdi is used to inspect and analyze the simulation waveforms.

The waveform screenshot demonstrates the simulation of the vending machine controller using the generated FSDB database.

### 8.1 Observed Signals

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 bit | Clock input |
| `rst` | 1 bit | Active-high reset |
| `coin5` | 1 bit | 5-unit coin input |
| `coin10` | 1 bit | 10-unit coin input |
| `dispense` | 1 bit | Product dispensing output |
| `change` | 1 bit | Change return output |

### 8.2 Verdi Simulation Waveform

![Vending Machine Verdi Waveform](screenshots/verdi_waveform.png)

Waveform analysis helps to:

- Inspect clock and reset behavior.
- Verify coin input transitions.
- Observe the FSM output behavior.
- Verify product dispensing conditions.
- Check change generation for the 20-unit transaction.
- Analyze sequential circuit behavior.
- Debug signal-level functionality.

---

## 9. Tools and Technologies

| Tool / Technology | Purpose |
|---|---|
| Verilog HDL | RTL design implementation |
| Finite State Machine | Controller architecture |
| Synopsys VCS | RTL compilation and simulation |
| Synopsys Verdi | Waveform visualization and debugging |
| FSDB | Simulation waveform database |
| VCD | Value Change Dump waveform format |
| Git | Version control |
| GitHub | Source code management and documentation |

---

## 10. Key Learning Outcomes

Through this project, the following concepts are explored:

- Sequential digital circuit design.
- Finite State Machine architecture.
- Moore FSM implementation.
- State encoding and state transitions.
- Clock and asynchronous reset implementation.
- Combinational next-state logic.
- Coin-based transaction control.
- Product dispensing and change generation.
- Verilog RTL modeling.
- Testbench development and functional verification.
- RTL simulation using Synopsys VCS.
- Waveform analysis and debugging using Synopsys Verdi.
- FSDB waveform generation and inspection.

---

## 11. Future Enhancements

Potential extensions to this project include:

- Implementing a Mealy FSM architecture.
- Adding support for additional coin denominations.
- Introducing multiple product selection options.
- Implementing product inventory management.
- Adding a transaction cancellation mechanism.
- Implementing a dedicated change-return mechanism.
- Developing a parameterized vending machine controller.
- Performing RTL synthesis and hardware area analysis.
- Evaluating timing performance and critical paths.
- Developing a SystemVerilog testbench with assertions and functional coverage.

---

## 12. Author

**SANTHOSH KUMAR N A**

RTL Design | Digital Design | VLSI Engineering

- GitHub: [Your GitHub Profile](https://github.com/your-username)
- LinkedIn: [Your LinkedIn Profile](https://linkedin.com/in/your-profile)

---

## 13. License

This project is intended for educational and learning purposes.

You are welcome to explore, modify, and extend the implementation with appropriate attribution.

---

<p align="center">
  <b>Designed with Verilog HDL | Simulated with Synopsys VCS | Debugged with Synopsys Verdi</b>
</p>

<p align="center">
  ⭐ If you find this project useful, consider starring the repository!
</p>

---

## GitHub Topics

verilog · verilog-hdl · vending-machine · finite-state-machine · fsm-design · moore-fsm · rtl-design · vlsi · digital-design · sequential-logic · synopsys-vcs · synopsys-verdi · fsdb · rtl-verification · asic-design · hardware-design
