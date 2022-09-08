class driver;

    transaciton tr; // tr is the data container
    virtual axi_if vif;

    mailbox #(transaciton) mbx;

    function new();
        this.mbx = mbx;
    endfunction
    
    task reset();
        //the system is active low reset
        //to access the vairiables we need interface .
        vif.resetn <= 1'b0;

        //resetting all the aw ports;
        vif.awvalid <= 1'b0;  
        vif.awready<= 1'b0;  
        vif.awid <= 3'b000; 
        vif.awlen <= 0; 
        vif.awsize <= 0; 
        vif.awaddr <= 0; 
        vif.awburst <= 0;

        //resetting all the data(w) ports
        vif.wvalid <=1'b0; 
        vif.wready <= 1'b0; 
        vif.wid <= 0; 
        vif.wdata <= 0; 
        vif.wstrb <= 0; 
        vif.wlast <= 0;

        /// reseting all the reponse ports
        vif. bready <= 1'b0; 
        vif. bvalid <= 1'b0; 
        vif.bid <= 0; 
        vif.bresp <= 0;

        //resseting all ar ports;
        vif. arvalid <= 1'b0;  
        vif. arready <= 1'b0;  
        vif.arid <= 0; 
        vif.arlen <= 0; 
        vif.arsize <= 0; 
        vif.araddr <= 0; 
        vif.arburst <= 0;

        //resetting all r data ports
        vif. rvalid <= 1'b0; 
        vif. rready <= 1'b0; 
        vif.rid <= 0; 
        vif.rdata <= 0; 
        vif.rstrb <= 0; 
        vif. rlast <= 0; 
        vif.rresp <= 0;
        repeat (5) @(posedge vif.clk)
        vif.resetn <= 1'b0;
        $display("Reset Completed");
    endtask

    //write data in fixed mode
    task write_fixed (input transaciton tr);
        int len = 0;
        len = tr.awlen + 1;
        $display("[DRV]: FIXED MODE -> DATA WRITE");
        @(posedge vif.vlk);
        vif.resetn <= 1'b1;
        vif.awvalid <= 1'b1;  
        vif.awready<= 1'b1;  
        vif.awid <= 1'b1; 
        vif.awlen <= tr.awlen;
        vif.awready <= 1'b1;  
        vif.awburst <= 2'b00; //indicates burst mode
        vif.awaddr <=  tr.awaddr;
        vif.rvalid <= 1'b0;  //read will 0 as it is only 
        vif.wvalid <= 1'b1;  //read will 0 as it is only 
        vif.wstrb <= 4'b1111; //all lanes are active
        vif.wdata <= $urandom_range(1,100);
        vif.wid <= tr.wid;
        vif.bready <= 1'b1;

        @(posedge vif.wready);
        @(posedge vif.clk);

        //generating 7 more data and address, in total 8, one is generated at the time of declaration
        for(int i = 0; i<len; i++) begin
            vif.wdata <= tr.wdata;
            vif.wdata <= $urandom_range(1,100);
            @(posedge vif.wready);
            @(posedge vif.clk);
        end
        
        vif.wlast <= 1'b1
        vif.wvalid <= 1'b0;
        vif.awvalid <= 1'b0;
        vif.arvalid <= 1'b0;
        @(posedge vif.clk);
        vif.wlast <= 1'b0;
        @(negedge vif.bvalid);
        -> drvnext;
    endtask

    task write_incr(input transaciton tr);
        int len = 0;
        len = tr.awlen + 1;
        $display("[DRV:] INCREMENT MODE -> DATA WRITE");
        @(posedge vif.vlk);
        vif.resetn <= 1'b1;
        vif.awvalid <= 1'b1;  
        vif.awready<= 1'b1;  
        vif.awid <= 1'b1; 
        vif.awlen <= tr.awlen;
        vif.awready <= 1'b1;  
        vif.awburst <= 2'b01; //indicates increment mode
        vif.awaddr <=  tr.awaddr;
        vif.rvalid <= 1'b0;  //read will 0 as it is only 
        vif.wvalid <= 1'b1;  //read will 0 as it is only 
        vif.wstrb <= 4'b1111; //all lanes are active
        vif.wdata <= $urandom_range(1,100);
        vif.wid <= tr.wid;
        vif.bready <= 1'b1;

        @(posedge vif.wready);
        @(posedge vif.clk);

        //generating 7 more data and address, in total 8, one is generated at the time of declaration
        for(int i = 0; i<len; i++) begin
            vif.awdata <= tr.awdata + 4*i;
            vif.wdata <= $urandom_range(1,100);
            @(posedge vif.wready);
            @(posedge vif.clk);
        end
        
        vif.wlast <= 1'b1
        vif.wvalid <= 1'b0;
        vif.awvalid <= 1'b0;
        vif.arvalid <= 1'b0;
        @(posedge vif.clk);
        vif.wlast <= 1'b0;
        @(negedge vif.bvalid);
        -> drvnext;
    endtask

    task write_wrap(input transaciton tr);
        int len = 0;
        len = tr.awlen + 1;
        $display("[DRV:] INCREMENT MODE -> DATA WRITE");
        @(posedge vif.vlk);
        vif.resetn <= 1'b1;
        vif.awvalid <= 1'b1;  
        vif.awready<= 1'b1;  
        vif.awid <= 1'b1; 
        vif.awlen <= tr.awlen;
        vif.awready <= 1'b1;  
        vif.awburst <= 2'b10; //indicates wrap mode
        vif.awaddr <=  tr.awaddr;
        vif.rvalid <= 1'b0;  //read will 0 as it is only 
        vif.wvalid <= 1'b1;  //read will 0 as it is only 
        vif.wstrb <= 4'b1111; //all lanes are active
        vif.wdata <= $urandom_range(1,100);
        vif.wid <= tr.wid;
        vif.bready <= 1'b1;

        @(posedge vif.wready);
        @(posedge vif.clk);

        for(int i = 0; i <7;i++)begin
            vif.awdata <= tr.addr_wraprd;  ///declare in the interface class, and directly assigned to the return address in the tb_top.
            vif.wdata <= $urandom_range(1,100);
        end
        vif.wlast <= 1'b1
        vif.wvalid <= 1'b0;
        vif.awvalid <= 1'b0;
        vif.arvalid <= 1'b0;
        @(posedge vif.clk);
        vif.wlast <= 1'b0;
        @(negedge vif.bvalid);
        -> drvnext;
    endtask
    
    //reading in fixed mode
    task read_fixed (input transaciton tr);
        int len = 0;
        len = tr.awlen + 1;
        $display("[DRV]: FIXED MODE -> DATA WRITE");
        @(posedge vif.vlk);
        vif.resetn <= 1'b1;
        vif.arvalid <= 1'b1;
        vif.arready <=1 1'b1;
        vif.arburst <= 2'b00;
        vif.rstrb <= 4'b1111;
        vif.rready <= 1'b1;
        vif.rid <= tr.id;
        vif.arlen <= tr.arlen;

        for(int i = 0; i < len, i++) begin 
            vif.araddr <= tr.araddr;
            @(posedge vif.clk);
            @(posedge vif.arready);
        end
        
        @(negedge vif.rlast);
        vif.rvalid <= 1'b0;
        vif.arvalid <= 1'b0;
        vif.rready <= 1'b0;
        -> drvnext;


    endtask       
   task read_incr (input transaciton tr);
        int len = 0;
        len = tr.awlen + 1;
        $display("[DRV]: FIXED MODE -> DATA WRITE");
        @(posedge vif.vlk);
        vif.resetn <= 1'b1;
        vif.arvalid <= 1'b1;
        vif.arready <=1 1'b1;
        vif.arburst <= 2'b00;
        vif.rstrb <= 4'b1111;
        vif.rready <= 1'b1;
        vif.rid <= tr.id;
        vif.arlen <= tr.arlen;

        for(int i = 0; i < len, i++) begin 
            vif.araddr <= tr.araddr + 4*1;
            @(posedge vif.clk);
            @(posedge vif.arready);
        end
        
        @(negedge vif.rlast);
        vif.rvalid <= 1'b0;
        vif.arvalid <= 1'b0;
        vif.rready <= 1'b0;

        -> drvnext;
    endtask   

       task read_wrap (input transaciton tr);
        int len = 0;
        len = tr.awlen + 1;
        $display("[DRV]: FIXED MODE -> DATA WRITE");
        @(posedge vif.vlk);
        vif.resetn <= 1'b1;
        vif.arvalid <= 1'b1;
        vif.arready <=1 1'b1;
        vif.arburst <= 2'b00;
        vif.rstrb <= 4'b1111;
        vif.rready <= 1'b1;
        vif.rid <= tr.id;
        vif.arlen <= tr.arlen;

        for(int i = 0; i < len, i++) begin 
            vif.araddr <= tr.addr_wraprd;;
            @(posedge vif.clk);
            @(posedge vif.arready);
        end
        
        @(negedge vif.rlast);
        vif.rvalid <= 1'b0;
        vif.arvalid <= 1'b0;
        vif.rready <= 1'b0;

        -> drvnext;
    endtask   

    task run();
        mbx.get(tr);
        
        //for the write 
        if(tr.awvalid == 1'b1) begin
            if(tr.awburst == 2'b00) begin
            write_fixed (tr);
        end
            else if(tr.awburst == 2'b01) begin
            write_incr(tr);
        end
            else if (tr.awburst == 2'b10) begin
            write_wrap(tr);
        end
    end
    if (tr.arvalid == 1'b1) begin
        if (tr.arburst == 2'b00)begin
            read_fixed(tr);
        end
        else if (tr.arburst == 2'b01) begin
            read_incr(tr);
        end
        else if (tr.arburst == 2'b10) begin
            read_wrap(tr);
        end

    end


    endtask


endclass