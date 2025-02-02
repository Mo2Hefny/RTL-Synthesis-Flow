# VLSI Design and Automation Project 🚀

## Overview
This project, developed as part of the CMP305 course at Cairo University, involves the design, testing, synthesis, and physical implementation of various RTL circuits. The project focuses on adders, multipliers, and a fully functional ALU, with all designs synthesized and routed using OpenLane.

## Features
- **Basic RTL Designs** ⚡
  - 32-bit signed integer adders:
    - ✅ **Carry Look-Ahead Adder (Optimal area, delay, and utilization)**
    - Ripple Carry Adder
    - Carry Bypass Adder
    - Carry Select Adder
  - 32-bit signed integer multipliers:
    - ✅ **Simple Multiplier (Best area efficiency for our ALU design)**
    - Multiplier Tree (combinational)
    - Sequential Multiplier (Had better area utilization, but we opted for non-sequential steps in our ALU 🚀)
    - Booth Algorithm
- **ALU Design** 🔧
  - Supports 32-bit floating-point addition and multiplication
  - Uses **Carry Look-Ahead Adder** and **Simple Multiplier** for optimal performance
  - Input/output registers and operation selection logic

## Testing 🛠️
Testbenches verify:
- ✅ Correctness of adders and multipliers under various conditions
- ✅ ALU functionality, including edge cases
- ✅ Automated pass/fail reporting with detailed outputs

## Synthesis & Implementation 🏗️
- Synthesized using **OpenLane** with:
  - Clock: 20ns, Input delay: 1ns, Output delay: 0.5ns
  - Utilization target: 60%
  - STA analysis included
- **Placement & Routing** with:
  - Clock skew constraint: 0.2ns
  - Vertical strip routing
  - Post-placement and post-routing simulations

## Deliverables 📦
- RTL source files (Verilog)
- Testbenches for functional verification
- OpenLane synthesis, STA, and routing reports
- Excel comparison of area, delay, and power for different designs
- Final GDS file for fabrication-ready implementation

## Tools Used 🛠️
- **Verilog** for RTL design
- **QuestaSim** for simulation
- **OpenLane** for synthesis and physical design

## Contributors 🤝
<table>
<tr>
  <td align="center">
        <a href="https://github.com/eslamwageh">
            <img src="https://avatars.githubusercontent.com/u/53353517?v=4" width="100;" alt="EssamWisam"/>
            <br />
            <sub><b>Eslam Wageh</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Mo2Hefny">
            <img src="https://avatars.githubusercontent.com/u/111001850?v=4" width="100;" alt="EssamWisam"/>
            <br />
            <sub><b>Moamen Hefny</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Mina-H-William">
            <img src="https://avatars.githubusercontent.com/u/118685507?v=4" width="100;" alt="Kariiem"/>
            <br />
            <sub><b>Mina Hany William</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Ashraf-Bahy">
            <img src="https://avatars.githubusercontent.com/u/111181298?v=4" width="100;" alt="Muhammad-saad-2000"/>
            <br />
            <sub><b>Ashraf Bahy</b></sub>
        </a>
    </td>
    </tr>
</table>


## <img  align= center width=50px height=50px src="https://media1.giphy.com/media/ggoKD4cFbqd4nyugH2/giphy.gif?cid=6c09b9527jpi8kfxsj6eswuvb7ay2p0rgv57b7wg0jkihhhv&rid=giphy.gif&ct=s"> License <a id = "license"></a>
This software is licensed under MIT License, See [License](https://github.com/eslamwageh/Grades-auto-filler/blob/main/LICENSE) for more information ©Moamen Hefny.
---

For detailed documentation and reports, refer to the repository files.

