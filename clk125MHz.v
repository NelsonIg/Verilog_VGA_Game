`timescale 1ns / 1ps


module Clk( input clk125MHz, output clk75MHz  );
wire feedback, clk75MHz_unbuff;

   MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKFBOUT_MULT_F(30.0),     // Multiply value for all CLKOUT (2.000-64.000).
      .CLKIN1_PERIOD(8.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      .CLKOUT0_DIVIDE_F(10.0),    // Divide amount for CLKOUT0 (1.000-128.000).
      .DIVCLK_DIVIDE(5)         // Master division value (1-106)
    )
   MMCME2_BASE_inst (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
      .CLKOUT0(clk75MHz_unbuff),     // 1-bit output: CLKOUT0
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT(feedback),   // 1-bit output: Feedback clock
      // Status Ports: 1-bit (each) output: MMCM status ports
      
      .CLKIN1(clk125MHz),       // 1-bit input: Clock
      .PWRDWN(0),       // 1-bit input: Power-down
      .RST(0),             // 1-bit input: Reset
      .CLKFBIN(feedback)      // 1-bit input: Feedback clock
   );
   BUFG BUFG_inst (
         .O(clk75MHz), // 1-bit output: Clock output
         .I(clk75MHz_unbuff)  // 1-bit input: Clock input
      );
endmodule
