`timescale 1ns / 1ps

module Balls(input clk125MHz, input [2:0] je,
            output vga_hs, output vga_vs,output [3:0] jd_n, jd_p,
            output [4:0] vga_r, output [5:0] vga_g, output [4:0]vga_b);
        wire clk75MHz;
        wire [24:0] VGA_Ctrl;
        wire [10:0] PixX;
        wire [9:0] PixY;
        wire Ziffer;
       
        wire MIDI_RDY;
        wire [7:0] MIDI_BYTE;
        wire clk500kHz;  
        wire [6:0] VALUE;
        wire [15:0] CTRLNUM;
       
        wire Ball;
        wire Kollision;
        wire Wall;
        wire [15:0]Punkte;
        
        
          
        Clk Clk_Inst(clk125MHz, clk75MHz);
       
        VGA1024 VGA1024_Inst(clk75MHz, VGA_Ctrl, PixX, PixY );
       
        Ziffer Ziffer_Instinput (clk75MHz,VGA_Ctrl,Punkte,CTRLNUM, Kollision, Ziffer);
       
        Ser2Par Ser2Par_Inst(clk500kHz, je[0], MIDI_RDY,MIDI_BYTE);
        
        MIDI_CTRL MIDI_CTRL_Inst(clk500kHz, MIDI_RDY, MIDI_BYTE, VALUE, CTRLNUM);
        
        Ball Ball_Inst(clk75MHz, PixX, PixY, ~VALUE, CTRLNUM, Ball );
        
        Wall Wall_Inst(clk75MHz, PixX , PixY, Ball, Wall,Kollision, Punkte);
       
        assign vga_hs = VGA_Ctrl[22]; // HSync
        assign vga_vs = VGA_Ctrl[23];// VSync 
       
      //assign {vga_r, vga_g, vga_b} =   (VGA_Ctrl[24] == 1)? (Ziffer)? 16'b1111111111111111: 16'b0 : 16'b0; // VGA_Ctrl[24] = Visible
       assign {vga_r, vga_g, vga_b} =   (VGA_Ctrl[24] == 1)? (Ball)? 16'b0000011111100000:(Ziffer)? 16'b0000011111100000: (Wall)? 16'b1111100000011111: 16'b0 :16'b0 ; // VGA_Ctrl[24] = Visible
        
       
        reg [7:0] counter500kHz;
        reg midi_clk;
        
               
        always@(posedge clk75MHz)begin
            counter500kHz = counter500kHz +1;
            if(counter500kHz == 75)begin
                counter500kHz <= 0;
                midi_clk <= ~midi_clk;
            end
            
        end
        
       
        assign clk500kHz = midi_clk;
        assign jd_p[0] = Kollision;
        assign jd_p[1] = Wall;
        assign jd_n[0] = Ball;
       
       
        
        
endmodule
