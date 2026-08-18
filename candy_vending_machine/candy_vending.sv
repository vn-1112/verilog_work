module candy_vending_with_CNCL_BUY(
  input clk, 
        rst, 
        CNCL, 
        BUY, 
        n, 
        d, 
        q,
  output dispense, 
         rN, 
         rD, 
         rQ
         );

typedef enum logic [4:0] {
             S0, S5, S10, S15, S20, S25, S30, S35, S40, S45, 
             S25B, S30B, S35B, S40B, S45B, 
             S30D, S45D, 
             RD1, RD2, RND1, RNQ2, RNDQ, RDQ1, RNQ1, RN2, RN1, 
             DUM, DUM2} st;
st ps, ns;

always@(*) begin
  ns = ps;
  case(ps)
    S0: begin
        if (q) ns = S25;
        else if (d) ns = S10;
        else if (n) ns = S5;
    end

    S5: begin 
        if (q) ns = S30;
        else if (d) ns = S15;
        else if (n) ns = S10;
        else if (CNCL) ns = RN1;
    end

    S10: begin
        if (q) ns = S35;
        else if (d) ns = S20;
        else if (n) ns = S15;
        else if (CNCL) ns = RD1;
    end
    S15: begin
        if (q) ns = S40;
        else if (d) ns = S25;
        else if (n) ns = S20;
        else if(CNCL) ns = RND1;
    end

    S20:  begin
        if (q) ns = S45;
        else if (d) ns = S30;
        else if (n) ns = S25;
        else if (CNCL) ns = RN2;
    end

    S25: begin
         if (BUY) ns = S25B;
         if (CNCL) ns = RD2;
    end
    
    S30: begin
         if (BUY) ns = S30B;
         if (CNCL) ns = RNQ1;
    end
    S35: begin
         if (BUY) ns = S35B;
         if(CNCL) ns = RDQ1;
    end
    S40: begin
         if (BUY) ns = S40B;
         if (CNCL) ns = RNDQ;
    end
    S45: begin
         if (BUY) ns = S45B;
         if (CNCL) ns = RNQ2;
    end

      RD1: ns = S0;
      RD2: ns = DUM2;
      RN1: ns = S0;
      RN2: ns = DUM2;
      RND1: ns = S0;
      RNQ1: ns = S0;
      RDQ1: ns = S0;
      RNDQ: ns = S0;
      RNQ2: ns = DUM2;

      DUM2: ns = RND1;
      
      S25B,
      S30B,
      S35B,
      S40B: ns = S0;
      S45B: ns = DUM;
      DUM: ns = RND1;

    default: ns = ps;
  endcase
end

//candy dispensed
assign dispense = (ps == S45B) |
                  (ps == S40B) |
                  (ps == S35B) |
                  (ps == S30B) |
                  (ps == S25B)
                  ;

// release nickel
assign rN = (ps == S30B) 
          | (ps == S40B)
          | (ps == S45B)
          | (ps == RN1)
          | (ps == RN2)
          | (ps == RND1)
          | (ps == RNQ1)
          | (ps == RNQ2)
          | (ps == RNDQ)
          ; 
          
// release dime
assign rD = (ps == S35B)
          | (ps == S40B)
          | (ps == RD1)
          | (ps == RD2)
          | (ps == RND1)
          | (ps == RDQ1)
          | (ps == RNDQ)
          ; 

// release quarter
assign rQ = (ps == RNQ1)
          | (ps == RNQ2)
          | (ps == RDQ1)
          | (ps == RNDQ)
          ;

  
  always@(posedge clk or negedge rst) begin
    if (~rst) begin
      ps <= S0;
    end
    else begin
      ps <= ns;
    end
  end

endmodule



