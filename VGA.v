`timescale 1ns / 1ps


module VGA1024(input clk75MHz, output [24:0] VGA_Ctrl, output reg[10:0] PixX, output reg [9:0] PixY );

  // reg [10:0] PixX = 11'd0;
   // reg [9:0]  PixY = 10'd0;
    reg vga_hs, vga_vs, visible;
    
    always@(posedge clk75MHz)begin
    
    visible <= PixX < 1024 && PixY < 768; 

    if(PixX == 1327)begin
        PixX <= 0;
        PixY <= (PixY == 805)? 0 : PixY +1;
    end
    else begin // Fehler
    PixX <= PixX + 1;
    
    vga_hs <=  (PixX < 1047) || (PixX >= 1183); 
    vga_vs <=  (PixY < 770) || (PixY >=776);
    end
  end
     
    //assign VGA_Ctrl[0] = clk75MHz;
    assign VGA_Ctrl = { visible, vga_vs, vga_hs, PixY, PixX ,clk75MHz};
    
    
endmodule
