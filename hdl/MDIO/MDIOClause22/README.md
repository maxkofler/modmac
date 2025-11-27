# MDIO Clause 22 IP Core

This directory contains a implementation of a **M**anagement **D**ata **I**nput **O**utput (MDIO) ip core.
Specifically, this core implements the Clause 22 variant.

# Register Description

The interface for this core is implemented as a single 32-bit register and is described as follows:

|      31- 29       |            28            |               27               |             26             |                 25-21                  |                     20 - 16                      |          15 - 0          |
| :---------------: | :----------------------: | :----------------------------: | :------------------------: | :------------------------------------: | :----------------------------------------------: | :----------------------: |
| Unused / Reserved | [Busy](#register---busy) | [Execute](#register---execute) | [Write](#register---write) | [PHY Address](#register---phy-address) | [Register Address](#register---register-address) | [Data](#register---data) |

## Register - Busy

## Register - Execute

## Register - Write

## Register - PHY Address

## Register - Register Address

## Register - Data

These bits of the control and status register serve double duty.
They contain the current data presented to the IP core.
If the [Write](#register---write) flag is set, this contains the data to be written to the PHY, otherwise, this will be populated by the data read from the PHY.
