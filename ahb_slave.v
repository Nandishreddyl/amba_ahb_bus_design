module ahb_slave(
input HCLK,
input HRESETn,
input [31:0] HADDR,
input [31:0] HWDATA,
input HWRITE,
input HSEL,


output reg [31:0] HRDATA,
output reg HREADY


);


reg [31:0] memory [0:255];
integer i;
initial begin
    for (i=0;i<256 ;i=i+1 ) 
    memory[i] = 32'h0000000;
    
end

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        HREADY <= 1;
        HRDATA <= 0;
    end else begin
        HREADY <= 1;

        if (HSEL) begin
            if (HWRITE)
                memory[HADDR[7:0]] <= HWDATA;
            else
                HRDATA <= memory[HADDR[7:0]];
        end
    end
end


endmodule