module qadd #(
	//Parameterized values
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
		res[N-2:0] = a[N-2:0] + b[N-2:0];	 	
		res[N-1] = a[N-1];				
															
															  
		end												
	//	one of them is negative...
	else if(a[N-1] == 0 && b[N-1] == 1) begin		
		if( a[N-2:0] > b[N-2:0] ) begin					
			res[N-2:0] = a[N-2:0] - b[N-2:0];			
			res[N-1] = 0;										
			end
		else begin												
			res[N-2:0] = b[N-2:0] - a[N-2:0];			
			if (res[N-2:0] == 0)
				res[N-1] = 0;										
			else
				res[N-1] = 1;										
			end
		end
	else begin												
		if( a[N-2:0] > b[N-2:0] ) begin					
			res[N-2:0] = a[N-2:0] - b[N-2:0];			
			if (res[N-2:0] == 0)
				res[N-1] = 0;										
			else
				res[N-1] = 1;										
			end
		else begin												
			res[N-2:0] = b[N-2:0] - a[N-2:0];			
			res[N-1] = 0;										
			end
		end
	end
endmodule

`timescale 1ns / 1ps

module tb_qadd;

// Parameters
parameter Q = 15;
parameter N = 32;

// Inputs
reg [N-1:0] a;
reg [N-1:0] b;

// Outputs
wire [N-1:0] c;

// Instantiate the qadd module
qadd #(Q, N) uut (
    .a(a), 
    .b(b), 
    .c(c)
);

// Initial block to apply test vectors
initial begin
    // Monitor the inputs and output
    $monitor("Time: %0d, a: %b, b: %b, c: %b", $time, a, b, c);
    
    // Test case 1: both positive
    a = 32'b00000000000000001111111111111111;  // 32767
    b = 32'b00000000000000000000000000000001;  // 1
    #10;

    // Test case 2: both negative
    a = 32'b10000000000000001111111111111111;  // -32767
    b = 32'b10000000000000000000000000000001;  // -1
    #10;

    // Test case 3: a positive, b negative, a > b
    a = 32'b00000000000000001111111111111111;  // 32767
    b = 32'b10000000000000000000000000000001;  // -1
    #10;

    // Test case 4: a positive, b negative, a < b
    a = 32'b00000000000000000000000000000001;  // 1
    b = 32'b10000000000000001111111111111111;  // -32767
    #10;

    // Test case 5: a negative, b positive, a > b
    a = 32'b10000000000000001111111111111111;  // -32767
    b = 32'b00000000000000000000000000000001;  // 1
    #10;

    // Test case 6: a negative, b positive, a < b
    a = 32'b10000000000000000000000000000001;  // -1
    b = 32'b00000000000000001111111111111111;  // 32767
    #10;

    // Test case 7: both zero
    a = 32'b00000000000000000000000000000000;  // 0
    b = 32'b00000000000000000000000000000000;  // 0
    #10;

    // Test case 8: one zero, one positive
    a = 32'b00000000000000000000000000000000;  // 0
    b = 32'b00000000000000001111111111111111;  // 32767
    #10;

    // Test case 9: one zero, one negative
    a = 32'b00000000000000000000000000000000;  // 0
    b = 32'b10000000000000001111111111111111;  // -32767
    #10;

    // Test case 10: large numbers, overflow check
    a = 32'b01111111111111111111111111111111;  // Large positive number
    b = 32'b01111111111111111111111111111111;  // Large positive number
    #10;

    // Test case 11: large negative numbers, overflow check
    a = 32'b10000000000000000000000000000001;  // Large negative number
    b = 32'b10000000000000000000000000000001;  // Large negative number
    #10;

    // End of test
    $finish;
end

endmodule
