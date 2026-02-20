# XII Interface Specification

This document describes the XII interface that is a internal interface that is used to connect various data paths within the ModMAC.

## Signal Description

| Signal | Direction | Type                          | Description |
| :----: | :-------: | :---------------------------- | :---------- |
|  `C`   |    OUT    | STD_LOGIC                     | Data Clock  |
|  `D`   |    OUT    | STD_LOGIC_VECTOR (7 downto 0) | Data Out    |
|  `E`   |    OUT    | STD_LOGIC                     | Data Enable |
|  `R`   |    IN     | STD_LOGIC                     | Data Ready  |

All signals shall be launched and latched at the rising edge of `C`.

### C - Clock

The clock signal is, as the name implies, the clock that the other signals are aligned to.
All the other signals shall be launched and latched at the rising edge of this signal.

### D - Data

The data signal conduit is responsible for transmitting one byte of data.

### E - Enable

A HIGH level at this signal tells the receiving end that the data that is being presented in this clock cycle shall be latched and interpreted as real data instead of ignoring it in empty clock cycles that have this signal at a LOW level.

### R - Ready

This signal allows a receiving end to tell the sending end whether it is able to receive new data or not.
In the case that the receiver can receive new data, it shall drive this signal HIGH, else LOW.
