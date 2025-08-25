module spi_master #(parameter DATA_WIDTH = 8)(
    input clk, rst,
    input [DATA_WIDTH-1:0]TX_DATA,
    input MISO,
    input tx_start,

    output reg sclk,
    output reg cs_n,
    output reg MOSI,
    output reg [DATA_WIDTH-1:0]RX_DATA //for cpu
);

    reg [DATA_WIDTH-1:0]shift_reg_mosi;
    reg [DATA_WIDTH-1:0]shift_reg_miso;
    reg [$clog2(DATA_WIDTH):0] count;

    parameter IDLE = 0,
              START = 1,
              TRANSFER = 2,
              STOP = 3;

    reg [1:0]state;

    always @(posedge clk) begin
        if(rst) begin
            MOSI <= 0;
            cs_n <= 1;
            sclk <= 0;
            RX_DATA <= 0;
            state <= IDLE;
            count <= DATA_WIDTH;
        end else begin
            case(state)
                IDLE: begin
                    MOSI <= 0;
                    cs_n <= 1;
                    sclk <= 0;
                    count <= DATA_WIDTH;
                    if(tx_start)
                        state <= START;
                end
                START: begin
                    cs_n <= 0;
                    shift_reg_mosi <= TX_DATA;
                    sclk <= 0;
                    state <= TRANSFER;
                end
                TRANSFER: begin
                    //transfering
                    MOSI <= shift_reg_mosi[DATA_WIDTH-1];
                    shift_reg_mosi <= {shift_reg_mosi[DATA_WIDTH-2:0], 1'b0};
                    //receiving
                    shift_reg_miso <= {shift_reg_miso[DATA_WIDTH-2:0], MISO};
                    //counter
                    count <= count - 1;
                    if(count == 1) begin
                        state <= STOP;
                    end else state <= TRANSFER;
                end
                STOP: begin
                    cs_n <= 1;
                    sclk <= 1;
                    RX_DATA <= shift_reg_miso;
                    state <= IDLE;
                end
            endcase
        end
    end

    always @(posedge clk or negedge clk) begin
        if(!cs_n)sclk <= 1;
    end
    always @(negedge clk) begin
        if(!cs_n)sclk <= 0;
    end

endmodule