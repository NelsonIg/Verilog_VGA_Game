`timescale 1ns / 1ps


module Ball(input clk75MHz, input [10:0] PixX, input [9:0] PixY, input [6:0] VALUE, input [7:0] CTRLNUM,  output reg Ball );

//    reg[15:0] BallTxt [7:0]; // xaddr 16 Bit, yaddr 7 Zeilen
//    reg[10:0] PosX = 11'd400;
//    reg[9:0] PosY = 11'd400;
    
//    wire [10:0] X = ~PixX;
//    wire [9:0] Y = PixY;
    
//    reg [15:0] Brow; //horizontale Pixelzeile des Balles
//    initial $readmemh("Ball.txt", BallTxt);
     
//    always@(posedge clk75MHz)begin
//        Brow <= BallTxt[Y];
        
//    end
    
//    wire [3:0] XPosInBall = {X[2:0], 1'b0};
//    wire [1:0] BallPixel = Brow >> XPosInBall;
//   assign Ball = (X<8 && Y<8 && BallPixel[1:0] == 2'b01);
   
   
   //***************** no Hit boX
    wire [6:0] BallValue = (VALUE == 127)? 126:VALUE;
    wire [10:0] BallPixX = PixX - BallValue*8; //Verschieben in X Richtung
    wire [9:0] BallPixY = PixY;
    
    wire [6:0] PosX = BallPixX [9:4];   // 1024 : 8 = 2^6 so oft passt Ball rein
    wire [6:0] PosY = BallPixY [9:4];   // 1024 : 8 = 2^6 so oft passt Ball rein
    
    wire [2:0] X = BallPixX [3:1];      // einzelnen Pixel
    wire [2:0] Y = BallPixY [3:1];      // einzelnen Pixel
    
    reg[7:0] BallNoHit [7:0]; //  reg[xzeile] name [yaddr]
    
    wire isAtPos = (PosX == 0) && (PosY == 30);
    
    initial $readmemh("BallNoHit.txt", BallNoHit);
    
    reg [7:0] Zeile;
    
    always@(posedge clk75MHz)begin
        
        Zeile <= BallNoHit[Y[2:0]];
        
        Ball <= (isAtPos)? Zeile[~X]: 1'd0;
              
    end
    
      

endmodule
