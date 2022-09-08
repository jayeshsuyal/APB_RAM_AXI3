class monitor;

    virtual axi_if vif;
    transaciton tr;
    mailbox #(transaciton) mbxms;  //mon - sco
    event sconext;

    function new();
        this.mbxms = mbxms;
    endfunction 

    task run();

        tr = new();
        forever 
        begin

            
            @(posedge vif.clk);

            //write data
            if(vif.awvalid == 1'b1)begin
                len = vif.awlen +1;
                tr.awvalid <= vif.awvalid;
                tr.arvalid <= vif.arvalid;
                
                for(int i = 0; i<len; i++) begin
                    @(posedge vif.wready);
                    @(posedge vif.clk);
                    tr.wdata <= vif.wdata;
                    tr.awaddr <= vif.awaddr;
                    tr.awburst <= vif.awburst;
                    @mbxms.put(tr);
                    $display("[MON]:- DATA: %0d, ADDR: %0d, BURST_MODE:%0d", tr.wdata, tr.awaddr, tr.awburst);
                end

                @(posedge vif.clk);
                @(negedge vif.bvalid);
                @(posedge vif.clk); //matching clocks with the driver. 
                
                $display("[MON]: TRANSACTION COMPLETE");

            end
            //reading the data
            if (vif.arvalid == 1'b1)
             begin
                len = vif.awlen +1;
                tr.awvalid <= vif.awvalid;
                tr.arvalid <= vif.arvalid;

                for(int i = 0; i<len; i++) begin
                    @(posedge vif.rready);
                    @(posedge vif.clk);
                    tr.wdata <= vif.rdata;
                    tr.awaddr <= vif.araddr;
                    tr.awburst <= vif.arburst;
                    @mbxms.put(tr);
                    $display("[MON]:- DATA: %0d, ADDR: %0d, BURST_MODE:%0d", tr.rdata, tr.araddr, tr.arburst);
                end
                @(posedge vif.clk);
                @(negedge vif.bvalid);
                @(posedge vif.clk); //matching clocks with the driver. 
                
                $display("[MON]: READ COMPLETE");
            end 
            -> sconext;
        end

    endtask

endclass