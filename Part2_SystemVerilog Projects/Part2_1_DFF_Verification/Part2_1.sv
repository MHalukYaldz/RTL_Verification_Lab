`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

/*////////////////////       REFERENCE DUT      /////////////////////////////////////
// Define a module named "dff" with an interface "dff_if"
 
module dff (dff_if vif);
 
  // Always block triggered on the positive edge of the clock signal
  always @(posedge vif.clk)
    begin
      // Check if the reset signal is asserted
      if (vif.rst == 1'b1)
        // If reset is active, set the output to 0
        vif.dout <= 1'b0;
      else
        // If reset is not active, pass the input value to the output
        vif.dout <= vif.din;
    end
  
endmodule
 
// Define an interface "dff_if" with the following signals
interface dff_if;
  logic clk;   // Clock signal
  logic rst;   // Reset signal
  logic din;   // Data input
  logic dout;  // Data output
  
endinterface
/////////////////////////////////////////////////////////////////////////////////*/


class transaction;
  rand bit din;    // Define a random input bit "din"
  bit dout;        // Define an output bit "dout"
  
  function transaction copy();
    copy = new();   // Create a new transaction object
    copy.din = this.din;  // Copy the input value
    copy.dout = this.dout;  // Copy the output value
  endfunction
  
  function void display(input string tag);
    $display("[%0s] : DIN : %0b DOUT : %0b", tag, din, dout); // Display transaction information
  endfunction
  
endclass
 
//////////////////////////////////////////////////
 
class generator;
  transaction tr;  // Define a transaction object
  mailbox #(transaction) mbx;      // Create a mailbox to send data to the driver
  mailbox #(transaction) mbxref;   // Create a mailbox to send data to the scoreboard for comparison/golden data
  event sconext; // Event to sense the completion of scoreboard work
  event done;    // Event to trigger when the requested number of stimuli is applied
  int count;     // Stimulus count
 
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx;  // Initialize the mailbox for the driver
    this.mbxref = mbxref; // Initialize the mailbox for the scoreboard
    tr = new(); // Create a new transaction object
  endfunction
  
  task run();
    repeat(count) begin
      assert(tr.randomize) else $error("[GEN] : RANDOMIZATION FAILED");
      mbx.put(tr.copy); // Put a copy of the transaction into the driver mailbox
      mbxref.put(tr.copy); // Put a copy of the transaction into the scoreboard mailbox
      tr.display("GEN"); // Display transaction information
      @(sconext); // Wait for the scoreboard's completion signal
    end
    ->done; // Trigger "done" event when all stimuli are applied
  endtask
  
endclass
 
//////////////////////////////////////////////////////////
 
class driver;
  transaction tr; // Define a transaction object
  mailbox #(transaction) mbx; // Create a mailbox to receive data from the generator
  virtual dff_if vif; // Virtual interface for DUT
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx; // Initialize the mailbox for receiving data
  endfunction
  
  task reset();
    vif.rst <= 1'b1; // Assert reset signal
    repeat(5) @(posedge vif.clk); // Wait for 5 clock cycles
    vif.rst <= 1'b0; // Deassert reset signal
    @(posedge vif.clk); // Wait for one more clock cycle
    $display("[DRV] : RESET DONE"); // Display reset completion message
  endtask
  
  task run();
    forever begin
      mbx.get(tr); // Get a transaction from the generator
      vif.din <= tr.din; // Set DUT input from the transaction
      @(posedge vif.clk); // Wait for the rising edge of the clock
      tr.display("DRV"); // Display transaction information
      vif.din <= 1'b0; // Set DUT input to 0
      @(posedge vif.clk); // Wait for the rising edge of the clock
    end
  endtask
  
endclass
 
//////////////////////////////////////////////////////
 
class monitor;
  transaction tr; // Define a transaction object
  mailbox #(transaction) mbx; // Create a mailbox to send data to the scoreboard
  virtual dff_if vif; // Virtual interface for DUT
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx; // Initialize the mailbox for sending data to the scoreboard
  endfunction
  
  task run();
    tr = new(); // Create a new transaction
    forever begin
      repeat(2) @(posedge vif.clk); // Wait for two rising edges of the clock
      tr.dout = vif.dout; // Capture DUT output
      mbx.put(tr); // Send the captured data to the scoreboard
      tr.display("MON"); // Display transaction information
    end
  endtask
  
endclass
 
////////////////////////////////////////////////////
 
class scoreboard;
  transaction tr; // Define a transaction object
  transaction trref; // Define a reference transaction object for comparison
  mailbox #(transaction) mbx; // Create a mailbox to receive data from the driver
  mailbox #(transaction) mbxref; // Create a mailbox to receive reference data from the generator
  event sconext; // Event to signal completion of scoreboard work
 
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx; // Initialize the mailbox for receiving data from the driver
    this.mbxref = mbxref; // Initialize the mailbox for receiving reference data from the generator
  endfunction
  
  task run();
    forever begin
      mbx.get(tr); // Get a transaction from the driver
      mbxref.get(trref); // Get a reference transaction from the generator
      tr.display("SCO"); // Display the driver's transaction information
      trref.display("REF"); // Display the reference transaction information
      if (tr.dout == trref.din)
        $display("[SCO] : DATA MATCHED"); // Compare data and display the result
      else
        $display("[SCO] : DATA MISMATCHED");
      $display("-------------------------------------------------");
      ->sconext; // Signal completion of scoreboard work
    end
  endtask
  
endclass
 
////////////////////////////////////////////////////////
 
class environment;
  generator gen; // Generator instance
  driver drv; // Driver instance
  monitor mon; // Monitor instance
  scoreboard sco; // Scoreboard instance
  event next; // Event to signal communication between generator and scoreboard
 
  mailbox #(transaction) gdmbx; // Mailbox for communication between generator and driver
  mailbox #(transaction) msmbx; // Mailbox for communication between monitor and scoreboard
  mailbox #(transaction) mbxref; // Mailbox for communication between generator and scoreboard
  
  virtual dff_if vif; // Virtual interface for DUT
 
  function new(virtual dff_if vif);
    gdmbx = new(); // Create a mailbox for generator-driver communication
    mbxref = new(); // Create a mailbox for generator-scoreboard reference data
    gen = new(gdmbx, mbxref); // Initialize the generator
    drv = new(gdmbx); // Initialize the driver
    msmbx = new(); // Create a mailbox for monitor-scoreboard communication
    mon = new(msmbx); // Initialize the monitor
    sco = new(msmbx, mbxref); // Initialize the scoreboard
    this.vif = vif; // Set the virtual interface for DUT
    drv.vif = this.vif; // Connect the virtual interface to the driver
    mon.vif = this.vif; // Connect the virtual interface to the monitor
    gen.sconext = next; // Set the communication event between generator and scoreboard
    sco.sconext = next; // Set the communication event between scoreboard and generator
  endfunction
  
  task pre_test();
    drv.reset(); // Perform the driver reset
  endtask
  
  task test();
    fork
      gen.run(); // Start generator
      drv.run(); // Start driver
      mon.run(); // Start monitor
      sco.run(); // Start scoreboard
    join_any
  endtask
  
  task post_test();
    wait(gen.done.triggered); // Wait for generator to complete
    $finish(); // Finish simulation
  endtask
  
  task run();
    pre_test(); // Run pre-test setup
    test(); // Run the test
    post_test(); // Run post-test cleanup
  endtask
endclass
 
/////////////////////////////////////////////////////
 
module Part2_001;
  dff_if vif(); // Create DUT interface
 
  dff dut(vif); // Instantiate DUT
  
  initial begin
    vif.clk <= 0; // Initialize clock signal
  end
  
  always #10 vif.clk <= ~vif.clk; // Toggle the clock every 10 time units
  
  environment env; // Create environment instance
 
  initial begin
    env = new(vif); // Initialize the environment with the DUT interface
    env.gen.count = 30; // Set the generator's stimulus count
    env.run(); // Run the environment
  end
  
  initial begin
    $dumpfile("dump.vcd"); // Specify the VCD dump file
    $dumpvars; // Dump all variables
  end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


class transaction;
  logic din;    // Define a random input bit "din"
  logic dout;        // Define an output bit "dout"
  
  function transaction copy();
    copy = new();   // Create a new transaction object
    copy.din = this.din;  // Copy the input value
    copy.dout = this.dout;  // Copy the output value
  endfunction
  
  function void display(input string tag);
    $display("[%0s] : DIN : %0b DOUT : %0b", tag, din, dout); // Display transaction information
  endfunction
  
endclass
 
//////////////////////////////////////////////////
 
class generator;
  transaction tr;  // Define a transaction object
  mailbox #(transaction) mbx;      // Create a mailbox to send data to the driver
  mailbox #(transaction) mbxref;   // Create a mailbox to send data to the scoreboard for comparison/golden data
  event sconext; // Event to sense the completion of scoreboard work
  event done;    // Event to trigger when the requested number of stimuli is applied
  int count;     // Stimulus count
 
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx;  // Initialize the mailbox for the driver
    this.mbxref = mbxref; // Initialize the mailbox for the scoreboard
    tr = new(); // Create a new transaction object
  endfunction
  
  task run();
    repeat(count) begin
      //assert(tr.randomize) else $error("[GEN] : RANDOMIZATION FAILED");
      tr.din = 1'bx;
      mbx.put(tr.copy); // Put a copy of the transaction into the driver mailbox
      mbxref.put(tr.copy); // Put a copy of the transaction into the scoreboard mailbox
      tr.display("GEN"); // Display transaction information
      @(sconext); // Wait for the scoreboard's completion signal
    end
    ->done; // Trigger "done" event when all stimuli are applied
  endtask
  
endclass
 
//////////////////////////////////////////////////////////
 
class driver;
  transaction tr; // Define a transaction object
  mailbox #(transaction) mbx; // Create a mailbox to receive data from the generator
  virtual dff_if vif; // Virtual interface for DUT
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx; // Initialize the mailbox for receiving data
  endfunction
  
  task reset();
    vif.rst <= 1'b1; // Assert reset signal
    repeat(5) @(posedge vif.clk); // Wait for 5 clock cycles
    vif.rst <= 1'b0; // Deassert reset signal
    @(posedge vif.clk); // Wait for one more clock cycle
    $display("[DRV] : RESET DONE"); // Display reset completion message
  endtask
  
  task run();
    forever begin
      mbx.get(tr); // Get a transaction from the generator
      vif.din <= tr.din; // Set DUT input from the transaction
      @(posedge vif.clk); // Wait for the rising edge of the clock
      tr.display("DRV"); // Display transaction information
      vif.din <= 1'b0; // Set DUT input to 0
      @(posedge vif.clk); // Wait for the rising edge of the clock
    end
  endtask
  
endclass
 
//////////////////////////////////////////////////////
 
class monitor;
  transaction tr; // Define a transaction object
  mailbox #(transaction) mbx; // Create a mailbox to send data to the scoreboard
  virtual dff_if vif; // Virtual interface for DUT
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx; // Initialize the mailbox for sending data to the scoreboard
  endfunction
  
  task run();
    tr = new(); // Create a new transaction
    forever begin
      repeat(2) @(posedge vif.clk); // Wait for two rising edges of the clock
      tr.dout = vif.dout; // Capture DUT output
      mbx.put(tr); // Send the captured data to the scoreboard
      tr.display("MON"); // Display transaction information
    end
  endtask
  
endclass
 
////////////////////////////////////////////////////
 
class scoreboard;
  transaction tr; // Define a transaction object
  transaction trref; // Define a reference transaction object for comparison
  mailbox #(transaction) mbx; // Create a mailbox to receive data from the driver
  mailbox #(transaction) mbxref; // Create a mailbox to receive reference data from the generator
  event sconext; // Event to signal completion of scoreboard work
 
  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
    this.mbx = mbx; // Initialize the mailbox for receiving data from the driver
    this.mbxref = mbxref; // Initialize the mailbox for receiving reference data from the generator
  endfunction
  
  task run();
    forever begin
      mbx.get(tr); // Get a transaction from the driver
      mbxref.get(trref); // Get a reference transaction from the generator
      tr.display("SCO"); // Display the driver's transaction information
      trref.display("REF"); // Display the reference transaction information
      if (tr.dout == trref.din)
        $display("[SCO] : DATA MATCHED"); // Compare data and display the result
      else
        $display("[SCO] : DATA MISMATCHED");
      $display("-------------------------------------------------");
      ->sconext; // Signal completion of scoreboard work
    end
  endtask
  
endclass
 
////////////////////////////////////////////////////////
 
class environment;
  generator gen; // Generator instance
  driver drv; // Driver instance
  monitor mon; // Monitor instance
  scoreboard sco; // Scoreboard instance
  event next; // Event to signal communication between generator and scoreboard
 
  mailbox #(transaction) gdmbx; // Mailbox for communication between generator and driver
  mailbox #(transaction) msmbx; // Mailbox for communication between monitor and scoreboard
  mailbox #(transaction) mbxref; // Mailbox for communication between generator and scoreboard
  
  virtual dff_if vif; // Virtual interface for DUT
 
  function new(virtual dff_if vif);
    gdmbx = new(); // Create a mailbox for generator-driver communication
    mbxref = new(); // Create a mailbox for generator-scoreboard reference data
    gen = new(gdmbx, mbxref); // Initialize the generator
    drv = new(gdmbx); // Initialize the driver
    msmbx = new(); // Create a mailbox for monitor-scoreboard communication
    mon = new(msmbx); // Initialize the monitor
    sco = new(msmbx, mbxref); // Initialize the scoreboard
    this.vif = vif; // Set the virtual interface for DUT
    drv.vif = this.vif; // Connect the virtual interface to the driver
    mon.vif = this.vif; // Connect the virtual interface to the monitor
    gen.sconext = next; // Set the communication event between generator and scoreboard
    sco.sconext = next; // Set the communication event between scoreboard and generator
  endfunction
  
  task pre_test();
    drv.reset(); // Perform the driver reset
  endtask
  
  task test();
    fork
      gen.run(); // Start generator
      drv.run(); // Start driver
      mon.run(); // Start monitor
      sco.run(); // Start scoreboard
    join_any
  endtask
  
  task post_test();
    wait(gen.done.triggered); // Wait for generator to complete
    $finish(); // Finish simulation
  endtask
  
  task run();
    pre_test(); // Run pre-test setup
    test(); // Run the test
    post_test(); // Run post-test cleanup
  endtask
endclass
 
/////////////////////////////////////////////////////
 
module Part2_001;
  dff_if vif(); // Create DUT interface
 
  dff dut(vif); // Instantiate DUT
  
  initial begin
    vif.clk <= 0; // Initialize clock signal
  end
  
  always #10 vif.clk <= ~vif.clk; // Toggle the clock every 10 time units
  
  environment env; // Create environment instance
 
  initial begin
    env = new(vif); // Initialize the environment with the DUT interface
    env.gen.count = 30; // Set the generator's stimulus count
    env.run(); // Run the environment
  end
  
  initial begin
    $dumpfile("dump.vcd"); // Specify the VCD dump file
    $dumpvars; // Dump all variables
  end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


module dff (dff_if vif);
  
  always@(posedge vif.clk)
    begin
      if(vif.rst == 1'b1)
        vif.dout <= 1'b0;
      else if (vif.din >= 1'b0)
         vif.dout <= vif.din;
      else
         vif.dout <= 1'b0;
    end
  
endmodule
 
 
interface dff_if;
  logic clk;
  logic rst;
  logic din;
  logic dout;
  
endinterface
 


/////////TB Code:



class transaction;
  logic din = 1'bx;
  logic dout;
  
  function transaction copy();
    copy = new();
    copy.din = this.din;
    copy.dout = this.dout;
  endfunction
  
 
  
  function void display(input string tag);
    $display("[%0s] : DIN : %0b DOUT : %0b", tag,din, dout);
  endfunction
  
  
endclass
 
//////////////////////////////////////////////////
class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  event sconext;
  event done;
  int count;
  
  
  function new( mailbox #(transaction) mbx,  mailbox #(transaction) mbxref);
   this.mbx = mbx;
   this.mbxref = mbxref; 
    tr = new(); 
  endfunction
  
  
  task run();
    repeat(count) begin
      for(int i = 0; i<10; i++) begin
        assert(tr.randomize) else $error("[GEN] : RANDOMIZATION FAILED");
        mbx.put(tr.copy);
        mbxref.put(tr.copy);
        tr.display("GEN");
        @(sconext);
      end
    end
    ->done;
  endtask
  
  
endclass
//////////////////////////////////////////////////////////
 
class driver;
  
  transaction tr;
  mailbox #(transaction) mbx;
  virtual dff_if vif;
  
 
  
  
  
  function new( mailbox #(transaction) mbx);
   this.mbx = mbx;
  endfunction
  
  task reset();
    vif.rst <= 1'b1;
    repeat(5) @(posedge vif.clk);
    vif.rst <= 1'b0;
    @(posedge vif.clk);
    $display("[DRV] : RESET DONE");
  endtask
  
  
  task run();
    forever begin
      mbx.get(tr);
      vif.din <= tr.din;
      tr.display("DRV");
      @(posedge vif.clk);
    end
    endtask
  
endclass
 
//////////////////////////////////////////////////////
 
class monitor;
  
  transaction tr;
  mailbox #(transaction) mbx;
  virtual dff_if vif;
  
 
  
  function new( mailbox #(transaction) mbx);
   this.mbx = mbx;
  endfunction
  
  task run();
    tr = new();
    forever begin
       @(posedge vif.clk);
       @(posedge vif.clk);
       tr.dout = vif.dout;
       mbx.put(tr);
      tr.display("MON");
    end
  endtask
  
endclass
 
 
 
////////////////////////////////////////////////////
 
class scoreboard;
  
  transaction tr;
  transaction trref;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  event sconext;
 
 
  function new( mailbox #(transaction) mbx,  mailbox #(transaction) mbxref);
   this.mbx = mbx;
   this.mbxref = mbxref;
  endfunction
  
  task run();
    forever begin
      mbx.get(tr);
      mbxref.get(trref);
      tr.display("SCO");
      trref.display("REF");
      /*if(tr.dout == trref.din)
        $display("[SCO] : DATA MATCHED");
      else
        $display("[SCO] : DATA MISMATCHED");
      */
      if(trref.din == 1'bx && tr.dout == 1'b0) begin
        $display("[SCO] : Test Passed");
      end
      else if(tr.dout == trref.din) begin
        $display("[SCO] : DATA MATCHED");
      end
      else begin
        $display("[SCO] : DATA MISMATCHED");
      end
      $display("-------------------------------------------------");
      ->sconext;
    end
  endtask
/*
DIN = 1'bx olduğunda DOUT = 1'b0 değerini geçerli 
kabul edecek şekilde skor tahtasını değiştirin ve "Test Başarılı" mesajını görüntüleyin
*/
  
endclass
 
////////////////////////////////////////////////////////
 
class environment;
 
    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco; 
  
    
  
    event next;  /// gen -> sco
  
  mailbox #(transaction) gdmbx; ///gen - drv
    
     
  mailbox #(transaction) msmbx;  /// mon - sco
  
  mailbox #(transaction) mbxref; ///// gen -> sco
  
    virtual dff_if vif;
 
  
  function new(virtual dff_if vif);
       
    gdmbx = new();
    mbxref = new();
    
    gen = new(gdmbx, mbxref);
    drv = new(gdmbx);
    
    
    msmbx = new();
    mon = new(msmbx);
    sco = new(msmbx, mbxref);
    
    this.vif = vif;
    drv.vif = this.vif;
    mon.vif = this.vif;
    
    gen.sconext = next;
    sco.sconext = next;
  
 
  endfunction
  
  task pre_test();
    drv.reset();
  endtask
  
  task test();
  fork
    gen.run();
    drv.run();
    mon.run();
    sco.run();
  join_any
  endtask
  
  task post_test();
    wait(gen.done.triggered);  
    $finish();
  endtask
  
  task run();
    pre_test();
    test();
    post_test();
  endtask
  
  
endclass
 
/////////////////////////////////////////////////////
 module Part2_001;
    
   dff_if vif();
 
   dff dut (vif);
   
    initial begin
      vif.clk <= 0;
    end
    
    always #10 vif.clk <= ~vif.clk;
    
    environment env;
    
    
    
    initial begin
      env = new(vif);
      env.gen.count = 30;
      env.run();
    end
      
    
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
   
    
  endmodule