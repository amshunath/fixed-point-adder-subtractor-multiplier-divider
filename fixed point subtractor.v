module qsubtract #(
	parameter Q = 15,
	parameter N = 32
	)
	(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
    );

reg [N-1:0] res;

assign c = res;

always @(a,b) begin
	// both negative or both positive
	if(a[N-1] == b[N-1]) begin					
		res[N-2:0] = a[N-2:0] - b[N-2:0];		
		res[N-1] = a[N-1];							
														
															
		end												
	//	one of them is negative...
	else if(a[N-1] == 0 && b[N-1] == 1) begin		
		if( a[N-2:0] > b[N-2:0] ) begin					
			res[N-2:0] = a[N-2:0] + b[N-2:0];			
			res[N-1] = 0;										
			end
		else begin												
			res[N-2:0] = b[N-2:0] + a[N-2:0];		
			if (res[N-2:0] == 0)
				res[N-1] = 0;									
			else
				res[N-1] = 1;									
			end
		end
	else begin												
		if( a[N-2:0] > b[N-2:0] ) begin					
			res[N-2:0] = a[N-2:0] + b[N-2:0];			
			if (res[N-2:0] == 0)
				res[N-1] = 0;										
			else
				res[N-1] = 1;										
			end
		else begin												
			res[N-2:0] = b[N-2:0] + a[N-2:0];			
			res[N-1] = 0;										
			end
		end
	end
endmodule

`timescale 1ns / 1ps
/////////////////////////////////////
module tb_qsubtract;

parameter Q = 15;
parameter N = 32;

reg [N-1:0] a;
reg [N-1:0] b;

wire [N-1:0] c;

qsubtract #(Q, N) uut (
    .a(a), 
    .b(b), 
    .c(c)
);

initial begin
    $monitor("Time: %0d, a: %b, b: %b, c: %b", $time, a, b, c);
    
    a = 32'b00000000000000001111111111111111;
    b = 32'b00000000000000000000000000000001;
    #10;

    a = 32'b10000000000000001111111111111111;
    b = 32'b10000000000000000000000000000001;
    #10;

    a = 32'b00000000000000001111111111111111;
    b = 32'b10000000000000000000000000000001;
    #10;

    a = 32'b10000000000000001111111111111111;
    b = 32'b00000000000000000000000000000001;
    #10;

    a = 32'b00000000000000000000000000000000;
    b = 32'b00000000000000000000000000000000;
    #10;

    a = 32'b00000000000000000000000000000000;
    b = 32'b00000000000000001111111111111111;
    #10;

    a = 32'b00000000000000000000000000000000;
    b = 32'b10000000000000001111111111111111;
    #10;

    a = 32'b01111111111111111111111111111111;
    b = 32'b00000000000000000000000000000001;
    #10;

    a = 32'b10000000000000000000000000000001;
    b = 32'b10000000000000000000000000000001;
    #10;

    $finish;
end

endmodule
