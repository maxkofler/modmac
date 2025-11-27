# MDIO Clause 22 IP Core

This directory contains a implementation of a **M**anagement **D**ata **I**nput **O**utput (MDIO) ip core.
Specifically, this core implements the Clause 22 variant.

## Register Description

The interface for this core is implemented as a single 32-bit register and is described as follows:

|      31- 29       |            28            |               27               |             26             |                 25-21                  |                     20 - 16                      |          15 - 0          |
| :---------------: | :----------------------: | :----------------------------: | :------------------------: | :------------------------------------: | :----------------------------------------------: | :----------------------: |
| Unused / Reserved | [Busy](#register---busy) | [Execute](#register---execute) | [Write](#register---write) | [PHY Address](#register---phy-address) | [Register Address](#register---register-address) | [Data](#register---data) |

### Register - Busy

This flag is high as long as the core is busy and communicating with the PHY.

> [!WARNING]
>
> This flag may be removed in the future.
> The functionality will be moved to the [Execute](#register---execute) flag instead.

### Register - Execute

A rising edge on this flag will trigger a new transaction with the PHY.
The core will provide feedback via the [Busy](#register---busy) flag.

### Register - Write

If this flag is set, the contents of the [Data](#register---data) will be written to the PHY.
If it is cleared, the PHY data will be put into the [Data](#register---data) register.

### Register - PHY Address

The address of the PHY to communicate with.

### Register - Register Address

The address of the register to read from / write to in the PHY that is being communicated with.

### Register - Data

These bits of the control and status register serve double duty.
They contain the current data presented to the IP core.
If the [Write](#register---write) flag is set, this contains the data to be written to the PHY, otherwise, this will be populated by the data read from the PHY.
