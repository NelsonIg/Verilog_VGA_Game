`timescale 1ns / 1ps


module Ziffer(input clk75MHz, input [24:0] VGA_Ctrl, input [15:0]Punkte, input [7:0] CTRLNUM, input Kollision, output reg Ziffer);

    wire [4:0] posX = VGA_Ctrl[10:6]; // Bit 11 is nicht in Visible
    wire [4:0] posY =  VGA_Ctrl[21:17]; // 
    //Für ziffer
    wire [2:0] X =VGA_Ctrl[5:3]; // 
    wire [2:0] Y = VGA_Ctrl[16:14]; 
   
    reg Ziffer0;
    reg Ziffer1;
    reg Ziffer2;
    reg Ziffer3;
    
    reg HighZiffer0;
    reg HighZiffer1;
    reg HighZiffer2;
    reg HighZiffer3;
    
    reg [15:0] HighScore;

//wire [5:0] X = VGA_Ctrl[7:2]; // 
//wire [4:0] Y = VGA_Ctrl[18:14]; 

        
    reg[7:0] Hex [511:0]; //reg[xzeile] name [yaddr]
        
    wire isAtPos = (posX == 2  || posX ==4 || posX ==6 || posX ==8  || posX == 18  || posX ==20 || posX ==22 || posX ==24 ) && (posY == 2);
      
        
    initial $readmemh("Ziffer.txt", Hex);
    
    reg [7:0] Zeile0;
    reg [7:0] Zeile1;
    reg [7:0] Zeile2;
    reg [7:0] Zeile3;
    
    reg [7:0] HighZeile0;
    reg [7:0] HighZeile1;
    reg [7:0] HighZeile2;
    reg [7:0] HighZeile3;
    
    
    always@(posedge clk75MHz)begin
    
        HighScore <= (Kollision && (HighScore < Punkte))? Punkte : HighScore;
        
        Zeile3 <= Hex[{Punkte[15:12],Y[2:0]}];
        Zeile2 <= Hex[{Punkte[11:8],Y[2:0]}];
        Zeile1 <= Hex[{Punkte[7:4],Y[2:0]}];
        Zeile0 <= Hex[{Punkte[3:0],Y[2:0]}];
       
        //Last Score
        HighZeile3 <= Hex[{HighScore[15:12],Y[2:0]}];
        HighZeile2 <= Hex[{HighScore[11:8],Y[2:0]}];
        HighZeile1 <= Hex[{HighScore[7:4],Y[2:0]}];
        HighZeile0 <= Hex[{HighScore[3:0],Y[2:0]}];
                
        Ziffer0 <=( posX ==8)?  Zeile0 [~X]:0; // negieren, um Ziffer zu spiegeln
        Ziffer1 <=( posX ==6)?  Zeile1 [~X]:0; // negieren, um Ziffer zu spiegeln
        Ziffer2 <=( posX ==4)?  Zeile2 [~X]:0; // negieren, um Ziffer zu spiegeln
        Ziffer3 <=( posX ==2)?  Zeile3 [~X]:0; // negieren, um Ziffer zu spiegeln
       
        HighZiffer0 <=( posX ==24)?  HighZeile0 [~X]:0; // negieren, um Ziffer zu spiegeln
        HighZiffer1 <=( posX ==22)?  HighZeile1 [~X]:0; // negieren, um Ziffer zu spiegeln
        HighZiffer2 <=( posX ==20)?  HighZeile2 [~X]:0; // negieren, um Ziffer zu spiegeln
        HighZiffer3 <=( posX ==18)?  HighZeile3 [~X]:0; // negieren, um Ziffer zu spiegeln
        
        Ziffer <=(isAtPos && posX ==2)?  Ziffer3: (isAtPos && posX ==4)? Ziffer2: (isAtPos && posX ==6)?Ziffer1: (isAtPos && posX ==8)?Ziffer0:
          (isAtPos && posX ==18)?  HighZiffer3: (isAtPos && posX ==20)? HighZiffer2: (isAtPos && posX ==22)?HighZiffer1: (isAtPos && posX ==24)?HighZiffer0: 0;
          
        
    
    
    end


endmodule
