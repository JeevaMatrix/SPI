module spi_slave #(parameter DATA_WIDTH = 8)(
    input  wire sclk,        // SPI clock from master
    input  wire rst,         // Reset
    input  wire MOSI,        // Master Out Slave In
    input  wire cs_n,        // Chip Select (active low)
    input  wire [DATA_WIDTH-1:0] TXS_DATA,  // Data to send

    output reg  MISO,        // Master In Slave Out
    output reg  [DATA_WIDTH-1:0] RXS_DATA   // Received data
);

    reg [DATA_WIDTH-1:0] shift_reg_miso;
    reg [DATA_WIDTH-1:0] shift_reg_mosi;
    reg [$clog2(DATA_WIDTH):0] bit_count;

    // Shift in/out data on each SCLK edge
    always @(posedge sclk or posedge rst) begin
        if (rst) begin
            shift_reg_miso <= 0;
            shift_reg_mosi <= 0;
            bit_count      <= 0;
            MISO           <= 0;
            RXS_DATA       <= 0;
        end 
        else if (!cs_n) begin
            // Shift in MOSI
            shift_reg_mosi <= {shift_reg_mosi[DATA_WIDTH-2:0], MOSI};

            // Shift out MISO
            MISO <= shift_reg_miso[DATA_WIDTH-1];
            shift_reg_miso <= {shift_reg_miso[DATA_WIDTH-2:0], 1'b0};

            // Counter
            bit_count <= bit_count + 1;

            // Word received?
            if (bit_count == DATA_WIDTH-1) begin
                RXS_DATA <= shift_reg_mosi;
                bit_count <= 0;
                shift_reg_miso <= TXS_DATA; // load next data
            end
        end else RXS_DATA <= shift_reg_mosi;
    end

    // Load data when CS goes low
    always @(negedge cs_n or posedge rst) begin
        if (rst) begin
            shift_reg_miso <= 0;
        end else begin
            shift_reg_miso <= TXS_DATA;
            bit_count <= 0;
        end
    end
endmodule
