## What is it

The main idea behind this code is to calculate the S-parameters of unknown interconnective devices by solving a reversed matrix equation. Typical devices are waveguide coaxial adapters, cables, and transformers.

For example, if we have devices X, Y, and Z, we should connect devices X and Y to each other and measure their overall S-parameters obtaining the result A. Then we save measurements results into a file, let's say, "XY_A.s2p", and so on with the pairs of devices A and C, and B and C.

This allows us to measure devices that we can connect to only one port of two because of transformation coefficient or non-compliant connector type. Originally this code was written to measure the exact transmission coefficient of the coaxial waveguide adapter as the waveguide can't connect to the coaxial port of the VNA without another adapter.
## How to use

 1. Measure 3 pairs of 3 [unknown] devices using VNA.
 2. Save each measurement results into a separate file. Hardcoded filenames are XY_A.s2p, YZ_B.s2p and XZ_C.s2p. Feel free to use your own filenames but don't forget to fix code properly.
 3. Place all .s2p files into the same folder with files [**extraction_main.m**](https://github.com/Sanila-san/HamRadioSweets/blob/master/dut-s-parameters-extraction/extraction_main.m "extraction_main.m") and [**VreadS2P.m**](https://github.com/Sanila-san/HamRadioSweets/blob/master/dut-s-parameters-extraction/VreadS2P.m "VreadS2P.m").
 4. Run **extraction_main.m** in Octave or MATLAB.
 5. Check plots and calculated data in the tab-separated values files. 
 6. Load TSV-files into spreadsheet editor for further use.

> Written with [StackEdit](https://stackedit.io/).
