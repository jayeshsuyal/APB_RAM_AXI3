class scoreboard;
    
    transaciton tr;
    mailbox #(transaciton) mbxms;
    bit [7:0]data[128:0] = `{default:0};
    bit temp;
    int count;
    int len;


     function new();
        this.mbx = mbxms;
    endfunction

    task run();
        forever begin
            mbxms.get(tr);

            if (tr.awvalid==1'b1) begin
                data[tr.awaddr] = tr.awdata[7:0];
                data[tr.awaddr] = tr.awdata[15:8];
                data[tr.awaddr] = tr.awdata[23:16];
                data[tr.awaddr] = tr.awdata[31:24];
            end

            if (tr.arvalid == 1'b1) begin
                temp= {data[tr.araddr +3], data[tr.araddr +2], data[tr.araddr+1], data[tr.araddr]};
            end

            $display("The data is as follows:- ADDR: %0x, RDATA: %0d, TEMP:%0d",tr.araddr, tr.rdata,temp);

            if(temp == 32'bc0c0c0c) begin
                $display("[SCO]: DATA MATCHED: DATA EMPTY");
            end
            else if (tr.rdata = temp) begin
                $display("[SCO]: DATA MATCHED");
            end

            else begin
                $display("DATA MISMATCHED");
            end

        end


    endtask



endclass