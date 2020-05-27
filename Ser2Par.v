`timescale 1ns / 1ps


module Ser2Par(input clk500kHz, MIDI_IN,
               output reg MIDI_RDY, output reg[7:0] MIDI_BYTE);
               
       reg [1:0] Zustand = 0; //0: waiting, 1: sampling, 2: stopbit rdy
       reg [3:0] IN_BUF = 4'b1111; //idle = 1
      
       wire START = (IN_BUF == 4'b1100); // fallende Flanke -> Start
              
       reg [7:0] TIME; // in unitsof 2 µs (z.B. 17 -> 34 µs)
       
       always@(posedge clk500kHz)begin
       IN_BUF <= {IN_BUF[2:0],MIDI_IN};
        case(Zustand)
            2'd0:if(START)
            begin TIME <= 2; Zustand <= 1; end  
                    
                                                           
            2'd1: //bit sampling 26 + 16*n, n = 0-8
                begin
                    TIME <= TIME + 1;
                    if(TIME == 8'd26 || TIME == 8'd42 || TIME == 8'd58 || TIME == 8'd74 || TIME == 8'd90 || TIME == 8'd106 || TIME == 8'd122 || TIME == 8'd138)
                        MIDI_BYTE <= {MIDI_IN, MIDI_BYTE [7:1]};
                    if(TIME == 8'd154)begin
                        MIDI_RDY = 1'b1; Zustand <= 2'd2;
                        end
                end
            2'd2://Stop Bit
                begin
                    MIDI_RDY <= 0; Zustand <= 0;
                end
           default: Zustand <= 0; 
        endcase
    end
endmodule
