`timescale 1ns / 1ps


module Wall(input clk75MHz, input [10:0] PixX, input [9:0] PixY, input Ball, output reg Wall, Kollision, output reg [15:0]Punkte );
    reg [9:0] countFrame;
    reg [1:0] Zustand = 0;  
    reg [9:0] countX;
    reg [2:0] speed =1;
    
   // parameter zahl = 8'h11;
    
    wire [9:0] Ymove;
    wire [10:0] Xmove;   
    
    wire [10:0] WallPixX = PixX [10:0] -countX; // zum Verschieben
    wire [9:0] WallPixY = PixY [9:0] - countFrame [9:0];
    
    wire [4:0] PosX = WallPixX [9:7];   // 1024 : 8 = 2^7 so oft passt Ball rein
    wire [4:0] PosY = WallPixY [9:5];   // 1024 : 8 = 2^7 so oft passt Ball rein
    
       
//    reg [31:0] WallTxt1 = 32'hF0FFF00F; 
//    reg [31:0] WallTxt2 = 32'h0FF30FF0; 
//    reg [31:0] WallTxt3 = 32'hF090F090; 
//    reg [31:0] WallTxt4 = 32'h3FF0F0F3; 
//    reg [31:0] WallTxt5 = 32'hFF1006FF; 
//    reg [31:0] WallTxt6 = 32'hF93FF903; 
//    reg [31:0] WallTxt7 = 32'h0F0F06F0; 
//    reg [31:0] WallTxt8 = 32'h0FC003F0; 
//    reg [31:0] WallTxt9 = 32'hF0F0F930; 
//    reg [31:0] WallTxt10 = 32'h0FF0FF00;
    
       reg [16:0] WallTxt1 = 8'hF0; 
       reg [16:0] WallTxt2 = 8'h0F; 
       reg [16:0] WallTxt3 = 8'h90; 
       reg [16:0] WallTxt4 = 8'h3F; 
       reg [16:0] WallTxt5 = 8'h80; 
       reg [16:0] WallTxt6 = 8'h93; 
       reg [16:0] WallTxt7 = 8'hF0; 
       reg [16:0] WallTxt8 = 8'hFC; 
       reg [16:0] WallTxt9 = 8'hF0; 
       reg [16:0] WallTxt10 =8'h0F;  
    
   
    
    wire isAtPos1 = (PosY == 0);
    wire isAtPos2 = (PosY == 4);
    wire isAtPos3 = (PosY == 8);
    wire isAtPos4 = (PosY == 12);
    
    wire isAtPos6 = (PosY == 19);
    wire isAtPos7 = (PosY == 23);
    wire isAtPos8 = (PosY == 27);
    wire isAtPos9 = (PosY == 31);
    wire isAtPos10 = (PosY == 29);
    wire isAtPos5 = (PosY == 32);
    

     
    
    always@(posedge clk75MHz)begin
        //Wall <= (isAtPosTop)? WallTxtTop[PosX]: 1'd0;
        if (isAtPos1)         Wall <= WallTxt1[PosX];
        else if (isAtPos2)    Wall <= WallTxt2[PosX];
        else if (isAtPos3)    Wall <= WallTxt3[PosX];
        //else if (isAtPos4)    Wall <= WallTxt4[PosX];
       // else if (isAtPos5)    Wall <= WallTxt5[PosX];       
        else if (isAtPos6)    Wall <= WallTxt6[PosX];
        else if (isAtPos7)    Wall <= WallTxt7[PosX];
        else if (isAtPos8)    Wall <= WallTxt8[PosX];
        //else if (isAtPos9)    Wall <= WallTxt9[PosX];
        //else if (isAtPos10)    Wall <= WallTxt10[PosX];
        else                    Wall <= 1'd0;
        
        Kollision <= (Ball && Wall);
        if(Kollision)           Punkte <= 0;
        if(Kollision)           Zustand <= 0;
        if(PixX == 11'd1327 && PixY == 805)begin
              
              Punkte <= Punkte+1;
              
              case (Zustand)
                
                0:begin
                     speed <= 1;
                     countFrame <= countFrame +speed;
                     if(countFrame == 1023)begin
                          Zustand <= 2'd1;
                          WallTxt1 <= {~^WallTxt1[4:0], WallTxt1[7:1]};
                          WallTxt2 <= {~^WallTxt2[5:0], WallTxt2[7:1]};
                          WallTxt3 <= {~^WallTxt3[6:0], WallTxt3[7:1]};
                          WallTxt4 <= {~^WallTxt4[7:0], WallTxt4[7:1]};
                          WallTxt5 <= {~^WallTxt5[8:0], WallTxt5[7:1]};
                          WallTxt6 <= {~^WallTxt6[9:0], WallTxt6[7:1]};
                          WallTxt7 <= {~^WallTxt7[10:0], WallTxt7[7:1]};
                          WallTxt8 <= {~^WallTxt8[11:0], WallTxt8[7:1]};
                          //WallTxt9 <= {~^WallTxt9[12:0], WallTxt9[7:1]};
                         // WallTxt10 <= {~^WallTxt10[13:0], WallTxt10[7:1]};
                     end
                  end
                1: begin
                     countFrame <= countFrame +1;
                     countX <= (countFrame[8]) ? countX +speed: countX -speed;
                     if(countFrame == 1022)begin
                        Zustand <= 2'd2;
                        WallTxt1 <= {~^WallTxt1[4:0], WallTxt1[7:1]};
                        WallTxt2 <= {~^WallTxt2[5:0], WallTxt2[7:1]};
                        WallTxt3 <= {~^WallTxt3[6:0], WallTxt3[7:1]};
                        WallTxt4 <= {~^WallTxt4[7:0], WallTxt4[7:1]};
                        WallTxt5 <= {~^WallTxt5[8:0], WallTxt5[7:1]};
                        WallTxt6 <= {~^WallTxt6[9:0], WallTxt6[7:1]};
                        WallTxt7 <= {~^WallTxt7[10:0], WallTxt7[7:1]};
                        WallTxt8 <= {~^WallTxt8[11:0], WallTxt8[7:1]};
                        //WallTxt9 <= {~^WallTxt9[12:0], WallTxt9[7:1]};
                       // WallTxt10 <= {~^WallTxt10[13:0], WallTxt10[7:1]};
                     end
                   end
                2: begin
                     countFrame <= countFrame -1;
                     countX <= (countFrame[8]) ? countX +speed: countX -speed;
                     if(countFrame == 0)begin
                        Zustand <= 2'd1;
                        speed <= (speed == 5)? 5 : speed +1;
                     end
                  end
               endcase 
          end
   end
   
   
endmodule
