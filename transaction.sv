class transaction:

    int id = 0;
    //write address ports (aw)
  bit awvalid;  /// master is sending new address  
  bit awready;  /// slave is ready to accept request
  bit [3:0] awid; ////// unique ID for each transaction
  rand bit [3:0] awlen; ////// burst length AXI3 : 1 to 16, 
  rand bit [2:0] awsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
  rand bit [31:0] awaddr; ////write adress of transaction
  rand bit [1:0] awburst; // fixed, increment, wrap

  //write data channel

  bit wvalid; //// master -> new data
  bit wready; //// slave <- new data 
  bit [3:0] wid; /// unique id for transaction
  rand bit [31:0] wdata; //// data 
  rand bit [3:0] wstrb; //// lane having valid data
  bit wlast; //indicates the last transaciton

  // response channel
  bit bready; ///master is ready to accept response
  bit bvalid; //// slave has valid response
  bit [3:0] bid; ////unique id for transaction
  bit [1:0] bresp; //status of response

  //read address ports (ar)
  // similar ports as for the write
  bit arvalid;  
  bit arready;  
  bit [3:0] arid; 
  bit [3:0] arlen; 
  bit [2:0] arsize; 
  bit [31:0] araddr; 
  bit [1:0] arburst; 

    // read data r
    // have similar ports as write data
  bit rvalid; 
  bit rready; 
  bit [3:0] rid; 
  bit [31:0] rdata; 
  bit [3:0] rstrb; 
  bit rlast; 
  bit [1:0] rresp;//status of the read transfer


    constraint valid_c {
        arvalid != awvalid; 
    } // whenever we perform write opr. there should not be any tran. fromr read

endclass