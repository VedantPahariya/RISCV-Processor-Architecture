// registers

module register(
    input clk,
    input signed [63:0] wrt_data,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input RegWrite, //for the control for writing
    output signed [63:0] read_data_1,
    output signed [63:0] read_data_2,
    output signed [63:0] read_data_rd // Just for showing in GTKWave
);

    reg signed[63:0] register [0:31];
    
    initial begin
        $readmemh("./Registerlog.mem", register); 
    end

    reg signed[63:0] read_data_1_reg;
    reg signed [63:0] read_data_2_reg;
    reg signed [63:0] read_data_rd_reg;
    reg [4:0] rd_copy;

    always @ (*) begin
        read_data_1_reg = register[rs1];
        read_data_2_reg = register[rs2];
    end

   // Update register when wrt_data or rd changes
    // always @ (wrt_data or rd or RegWrite) begin
    //     if(RegWrite) begin
    //         register[rd] = wrt_data;
    //         read_data_rd_reg = register[rd];
    //         $display("\n --> Register %d updated to %d", rd, wrt_data);
    //         $writememh("Registerlog.mem", register);  // Save updated registers to file
    //     end
    // end

    assign read_data_1 = read_data_1_reg;
    assign read_data_2 = read_data_2_reg;
    assign read_data_rd = read_data_rd_reg;

    // here only at negative edge of clk we write the data
    always @ (negedge clk) begin
        //$display("RegWrite: %d", RegWrite);
        rd_copy = rd;
        if(RegWrite)
        begin 
            if (rd_copy == 0) begin
                $display("\n --> Register 0 cannot be updated");
            end
            else begin
            register[rd] = wrt_data;
            read_data_rd_reg = register[rd];
            $display("\n --> Register %d updated to %d", rd, wrt_data);
            $writememh("Registerlog.mem", register);  // Save updated registers to file
            //end
        end  
    end  
    else begin
        read_data_rd_reg = 63'bx;
    end
    end

endmodule