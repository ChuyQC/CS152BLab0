`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2026 06:11:35 PM
// Design Name: 
// Module Name: my_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter(
    input clk_1Hz,
    input rst,
    output reg [3:0] count
    );
   
always @(posedge clk_1Hz or posedge rst)
begin
     if (rst)
        count <= 4'b0;
    else if (count == 15)
        count <= 4'b0;
    else
        count <= count + 1;
end

 
   
endmodule

module clk_div(
    input clk_master,
    input rst,
    output reg clk_1Hz
);


parameter [31:0] clock_count = 32'd50000000; // 50 Mil
// Logic: clk_1Hz toggles every 50M cycles × 10ns = 0.5 seconds
// so full period (low -> high -> low) = 1 sec

reg [31:0] clock_div_reg;

always @(posedge clk_master or posedge rst)
begin
    if (rst)
        clock_div_reg <= 32'b0;
    else if (clock_div_reg == clock_count - 1)
        clock_div_reg <= 32'b0;
    else
        clock_div_reg <= clock_div_reg + 1;
end

always @ (posedge(clk_master), posedge(rst))
begin
    if (rst == 1'b1)
        clk_1Hz <= 1'b0;
    else if (clock_div_reg == clock_count - 1)
        clk_1Hz <= ~clk_1Hz;
    else
        clk_1Hz <= clk_1Hz;
end
    endmodule


module master_counter(
    input  clk,        // 100 MHz board clock
    input  btnD,
    output wire [3:0] leds
);

    // wire carries clk_1Hz from the divider INTO counter
    wire clk_1Hz_wire;

    
   
    clk_div divider (
        .clk_master (clk),
        .rst        (btnD),
        .clk_1Hz    (clk_1Hz_wire)   // output plugs into the wire
    );

    // Instantiate the counter, fed by that same wire
    counter counterSmall (
        .clk_1Hz (clk_1Hz_wire),     // wire plugs into input
        .rst     (btnD),
        .count   (leds)              // counter output goes straight to LEDs
    );

endmodule

// Simulation-only version, never synthesized
module clk_div_sim(
    input clk_master,
    input rst,
    output reg clk_1Hz
);
parameter [31:0] clock_count = 32'd10;  // tiny value, sim only
reg [31:0] clock_div_reg;

always @(posedge clk_master or posedge rst)
begin
    if (rst)
        clock_div_reg <= 32'b0;
    else if (clock_div_reg == clock_count - 1)
        clock_div_reg <= 32'b0;
    else
        clock_div_reg <= clock_div_reg + 1;
end

always @(posedge clk_master or posedge rst)
begin
    if (rst)
        clk_1Hz <= 1'b0;
    else if (clock_div_reg == clock_count - 1)
        clk_1Hz <= ~clk_1Hz;
end
endmodule