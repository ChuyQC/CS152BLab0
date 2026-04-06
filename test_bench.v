`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2026 06:12:55 PM
// Design Name: 
// Module Name: test_bench
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


module test_bench;
    reg  clk;
    reg  rst;
    wire clk_1Hz_wire;
    wire [3:0] count;

    // sim version of divider
    clk_div_sim divider (
        .clk_master (clk),
        .clk_1Hz    (clk_1Hz_wire)
    );

    counter uut (
        .clk_1Hz (clk_1Hz_wire),
        .rst     (rst),
        .count   (count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #20;
        rst = 0;
        #4500;
        rst = 1;
        #200;
        rst = 0;
        #8000;
        $finish;
    end
endmodule
