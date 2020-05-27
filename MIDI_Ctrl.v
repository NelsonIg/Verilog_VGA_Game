`timescale 1ns / 1ps

module MIDI_CTRL(input clk500kHz, MIDI_RDY, input [7:0] MIDI_BYTE,
                                output reg [6:0] VALUE, output reg [7:0] CTRLNUM );
    
     //parameter CTRLNUM = 8'h4A;
     
    reg [1:0] Zustand = 0; // 0: wait, 1: check cltr#, 2: get value
    
    always@(posedge clk500kHz)begin
        if(MIDI_RDY)begin
            case(Zustand)
                0: if(MIDI_BYTE == 8'hB0 || MIDI_BYTE == 8'h90 ||  MIDI_BYTE == 8'h80) Zustand <= 1;
                
                1:begin
                        if(MIDI_BYTE == 8'h4A || MIDI_BYTE == 8'h54 || MIDI_BYTE == 8'h53)begin //Regler, Rechts, Links
                          CTRLNUM <= MIDI_BYTE;
                          Zustand <= 2;
                        end
                    end
                
                    
                2:  begin
                        if(~MIDI_BYTE[7]) 
                            VALUE <= MIDI_BYTE[6:0];
                        Zustand <= 0;
                    end
                default: Zustand <= 0; 
            endcase
        end
    end
    
endmodule
