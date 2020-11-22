module cache(clk);
	input clk;
	real miss[0:4];
	real hit[0:4];
	reg valid[0:16383][3:0];                 // 16384 lines.
	reg [13:0]   index[0:16383];	       // 16384 lines with 14 bit size.
	reg [15:0]  tag[0:16383][3:0]; // 16384 lines of tag size 16(32-2-14).
	reg [31:0] address;
	reg [4:0] instruction;
	integer data_file,k,tmp,data1;

initial begin
k=0;
end
always @(posedge clk)
	begin
		for(k=0;k<5;k++)begin
			if(k==0)begin
				data_file=$fopen("gcc.trace","r");
			end
			else if(k==1)begin
				data_file =$fopen("gzip.trace","r");
			end
			else if(k==2)begin
				data_file = $fopen("mcf.trace","r");
			end
			else if(k==3)begin
				data_file = $fopen("swim.trace","r");
			end
			else if(k==4) begin
				data_file = $fopen("twolf.trace","r");
			end
			while(!$feof(data_file)) begin    // runs untill end of the line.
			tmp=$fscanf(data_file,"%s%h%h\n",instruction,address,data1);  // read the contents of the file and store in respective variables.
			// ----------------------------------  load instruction ----------------------------------------------------------			
			if(instruction==5'h0c)
			begin
				if(valid[address[15:2]][0]==0)
				begin
					valid[address[15:2]][0]=1;
					index[address[15:2]]=address[15:2];
					tag[address[15:2]][0]=address[31:16];
					miss[k]=miss[k]+1;
				end
				else 
				begin
			       		if(tag[address[15:2]][0]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end
					else if(tag[address[15:2]][1]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end
					else if(tag[address[15:2]][2]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end
					else if(tag[address[15:2]][3]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end					
					else
					begin
						index[address[15:2]]=address[15:2];
						tag[address[15:2]][0]=address[31:16];
						miss[k]=miss[k]+1;
					end
				
				end
			end	
		// ---------------------------------------------------------------------------------------------------------------

		// ----------------------------------  store instruction ---------------------------------------------------------
			if(instruction == 5'h13)
			begin
				if(valid[address[15:2]][0]==0)
				begin
					miss[k]=miss[k]+1;
				end
				else
				begin
					index[address[15:2]]=address[15:2];
					if(tag[address[15:2]][0]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end
					else if(tag[address[15:2]][1]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end
					else if(tag[address[15:2]][2]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end
					else if(tag[address[15:2]][3]==address[31:16])
					begin	
							hit[k]=hit[k]+1;
					end					
					else
					begin
						tag[address[15:2]][0]=address[31:16];
						miss[k]=miss[k]+1;
					end
				end
			end
		// -----------------------------------------------------------------------------------------------------------------
			end 
			if(k==0)begin
				$display("gcc.trace:\n");
			end	
			else if(k==1)begin
				$display("gzip.trace:\n");
			end
			else if(k==2) begin
				$display("mcf.trace:\n");
			end
			else if(k==3) begin
				$display("swim.trace:\n");
			end
			else if(k==4) begin	
				$display("twolf.trace:\n");
			end
			$display("%f\t%f",hit[k]/(hit[k]+miss[k])*100,miss[k]/(hit[k]+miss[k])*100);   // printing hit ratio and miss ratio.
			$fclose(data_file);
		end
end
endmodule
