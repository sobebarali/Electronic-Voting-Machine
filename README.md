# Electronic-Voting-Machine

In this project, an attempt has been made to show the Architectural Design (RTL Design) and Func-
tional Verification and Simulation of Electronic Voting Machine’s Protocol. Primarily we have come to

this project approach by looking at the design of an existing microprocessor and microcontroller based
Electronic Voting Machine.

When we compare the architectural differences of our design with reference to the existing micro-
processor based EVM system, we get to see the following points –

■ They used 8086 Microprocessor to execute various instructions; but in our project, we used specific

digital circuit to perform all the instruction which are needed without the use of 8086 Micropro-
cessor.

■ They used Two EEPROMs as odd bank and even bank memory to store 16-bit data. These EEP-
ROMs store the main operating system, acts like RAM during instruction execution and also store

voting information. But in our project, we used single EAPROM which perform the same opera-
tion.

Basically, in the existing design they had created a general purpose architecture. But, in this project
we are mainly doing application specific architectural design which is purely for a particular application.
Also we have realized the need for a framework that can offer some of the best technology for designing
an Electronic Voting Machine. Since we all understand that it is laborious to manage control signals,
here we have tried to structure the RTL design of Electronic Voting Machines in Verilog HDL.
