module tb_ahb;

reg HCLK;
reg HRESETn;

// Instantiate TOP with proper connections
ahb_top uut(
    .HCLK(HCLK),
    .HRESETn(HRESETn)
);

// 🔁 Clock Generation (10 time unit period)
initial begin
    HCLK = 0;
    forever #5 HCLK = ~HCLK;
end

// 🔄 Reset + Simulation Control
initial begin
    HRESETn = 0;     // Apply reset
    #10 HRESETn = 1; // Release reset

    #100 $finish;    // End simulation
end

// 📊 Dump file for GTKWave
initial begin
    $dumpfile("ahb.vcd");
    $dumpvars(0, tb_ahb);
end

endmodule
