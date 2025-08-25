`include "spi_master.v"
`include "spi_slave.v"

module spi_top #(parameter DATA_WIDTH = 8)(
    input clk,
    input rst,
    input tx_start,
    input [DATA_WIDTH-1:0] master_tx_data,
    input [DATA_WIDTH-1:0] slave_tx_data,

    output [DATA_WIDTH-1:0] master_rx_data,
    output [DATA_WIDTH-1:0] slave_rx_data
);

    wire sclk, cs_n, MOSI, MISO;

    spi_master #(.DATA_WIDTH(DATA_WIDTH)) master (
        .clk(clk),
        .rst(rst),
        .TX_DATA(master_tx_data),
        .MISO(MISO),
        .tx_start(tx_start),
        .sclk(sclk),
        .cs_n(cs_n),
        .MOSI(MOSI),
        .RX_DATA(master_rx_data)
    );

    spi_slave #(.DATA_WIDTH(DATA_WIDTH)) slave (
        .sclk(sclk),
        .rst(rst),
        .MOSI(MOSI),
        .cs_n(cs_n),
        .TXS_DATA(slave_tx_data),
        .MISO(MISO),
        .RXS_DATA(slave_rx_data)
    );

endmodule
