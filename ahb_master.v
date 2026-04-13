module ahb_master(
input HCLK,
input HRESETn,
input HREADY,
input [31:0] HRDATA,


output reg [31:0] HADDR,
output reg [31:0] HWDATA,
output reg HWRITE,
output reg [1:0] HTRANS


);


reg [2:0] count;
reg phase; // 0 = write, 1 = read

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        HADDR  <= 0;
        HWDATA <= 32'h11111111;
        HWRITE <= 0;
        HTRANS <= 2'b00;
        count  <= 0;
        phase  <= 0;
    end else begin

        // ---------------- WRITE BURST ----------------
        if (phase == 0) begin
            if (count == 0) begin
                HADDR  <= 32'h00000000;
                HWRITE <= 1;
                HTRANS <= 2'b10; // NONSEQ
                count  <= 1;
            end
            else if (count < 4) begin
                HADDR  <= HADDR + 4;
                HWDATA <= HWDATA + 1;
                HTRANS <= 2'b11; // SEQ
                count  <= count + 1;
            end
            else begin
                // switch to read
                count  <= 0;
                phase  <= 1;
                HTRANS <= 2'b00;
            end
        end

        // ---------------- READ BURST ----------------
        else begin
            if (count == 0) begin
                HADDR  <= 32'h00000000;
                HWRITE <= 0; // READ
                HTRANS <= 2'b10; // NONSEQ
                count  <= 1;
            end
            else if (count < 4) begin
                HADDR  <= HADDR + 4;
                HTRANS <= 2'b11; // SEQ
                count  <= count + 1;
            end
            else begin
                HTRANS <= 2'b00; // IDLE
            end
        end

    end
end


endmodule