class generator
    
    transaciton tr;
    mailbox #(transaction) mbx;
    event done;
    event sconext;
    event drvnext;

    function new();
        this.mbx = mbx;
        tr = new();
    endfunction

    ///randomize all the variable in the tr class

    task run();
        repeat(count) begin
            assert(tr.randomize) else $display("Randomization Failed.!!");
            mbx.put(tr);
            @(drvnext);
            @(sconext);
        end
        -> done;
    endtask


endclass