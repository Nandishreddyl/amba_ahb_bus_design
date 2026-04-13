module ahb_top(
input HCLK,
input HRESETn
);


// Master signals
wire [31:0] HADDR;
wire [31:0] HWDATA;
wire [31:0] HRDATA;
wire HWRITE;
wire HREADY;
wire [1:0] HTRANS;

// Slave signals
wire [31:0] HRDATA1, HRDATA2;
wire HREADY1, HREADY2;
wire HSEL1, HSEL2;

// -------------------------
// Address Decoder
// -------------------------
assign HSEL1 = (HADDR < 32'h00000100);
assign HSEL2 = (HADDR >= 32'h00000100);

// -------------------------
// MASTER
// -------------------------
ahb_master master(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HREADY(HREADY),
    .HRDATA(HRDATA),
    .HADDR(HADDR),
    .HWDATA(HWDATA),
    .HWRITE(HWRITE),
    .HTRANS(HTRANS)
);

// -------------------------
// SLAVE 1
// -------------------------
ahb_slave slave1(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HADDR(HADDR),
    .HWDATA(HWDATA),
    .HWRITE(HWRITE),
    .HSEL(HSEL1),
    .HRDATA(HRDATA1),
    .HREADY(HREADY1)
);

// -------------------------
// SLAVE 2
// -------------------------
ahb_slave slave2(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HADDR(HADDR),
    .HWDATA(HWDATA),
    .HWRITE(HWRITE),
    .HSEL(HSEL2),
    .HRDATA(HRDATA2),
    .HREADY(HREADY2)
);

// -------------------------
// MUX (Select active slave)
// -------------------------
assign HRDATA = (HSEL1) ? HRDATA1 : HRDATA2;
assign HREADY = HREADY1 | HREADY2;


endmodule