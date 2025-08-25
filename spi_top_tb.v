`timescale 1ns/1ns
`include "spi_top.v"

module spi_top_tb;

    parameter DATA_WIDTH = 8;
    reg clk, rst, tx_start;
    reg [DATA_WIDTH-1:0] master_tx_data, slave_tx_data;
    wire [DATA_WIDTH-1:0] master_rx_data, slave_rx_data;

    spi_top #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .master_tx_data(master_tx_data),
        .slave_tx_data(slave_tx_data),
        .master_rx_data(master_rx_data),
        .slave_rx_data(slave_rx_data)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock

    initial begin
        rst = 1;
        tx_start = 0;
        master_tx_data = 8'hA5;
        slave_tx_data  = 8'h3C;

        #20 rst = 0;
        #10 tx_start = 1;
        #10 tx_start = 0;

        // Wait for transfer to complete
        #200;

        $display("Master received: %h", master_rx_data);
        $display("Slave received:  %h", slave_rx_data);

        $finish;
    end

    initial begin
        $dumpfile("spi_top.vcd");
        $dumpvars(0, spi_top_tb);
    end

endmodule
