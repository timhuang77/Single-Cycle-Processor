library ieee;
use ieee.std_logic_1164.all;
--include packages
use WORK.eecs361_gates.all;
use WORK.eecs361.all;

use package

entity processor is
	port (
		-- clock
		clk : in std_logic;
		
		-- Immediate Input Bus
		imm16 : in std_logic_vector(15 downto 0);
		
		-- Register Addr Signals -- (5-bit addr)
		Rs : in std_logic_vector(4 downto 0);
		Rt : in std_logic_vector(4 downto 0);
		Rd : in std_logic_vector(4 downto 0);
				
		-- Control Signals --
		nPC_sel : in std_logic;
		ALU_ctrl : in std_logic_vector(3 downto 0);
		RegDst : in std_logic;
		RegWr : in std_logic;
		ExtOp : in std_logic;
		ALU_src : in std_logic;
		MemWrite : in std_logic;
		MemToReg : in std_logic;
		);
end entity processor;

architecture datapath of processor is
--components
component ALU_32 is
	port (
		--Inputs:
		op : in std_logic_vector(3 downto 0);
		c_in : in std_logic;
		x : in std_logic_vector(31 downto 0);
		y : in std_logic_vector(31 downto 0);
		--Outputs:
		z : out std_logic_vector(31 downto 0);
		c_out : out std_logic;
		
		--Output Flags:
		overflow_flag : out std_logic;
		zero_flag : out std_logic
	);
end component ALU_32;
--types
--signals
signal Rw_signal : std_logic_vector(4 downto 0);
signal busA_signal : std_logic_vector(31 downto 0);
signal busB_signal : std_logic_vector(31 downto 0);
signal busW_signal : std_logic_vector(31 downto 0);
signal ALU_to_Mux_signal : std_logic_vector(31 downto 0);
signal RegMux_to_ALU_signal : std_logic_vector(31 downto 0);
signal DataMem_to_Mux_signal : std_logic_vector(31 downto 0);
signal extender_to_Mux_signal : std_logic_vector(31 downto 0);

begin
	--Data Memory component
	DataMemory : syncram 
		generic map () 
		port map(clk => clk, cs => '1', oe => '1', we => MemWrite, addr => ALU_to_Mux_signal, din => busB_signal, dout => DataMem_to_Mux_signal);
			--OE currently 1, but could be modified to output based on control logic
	
	--Data Mem to Register Mux
	MUX_MemToReg : mux_32 port map(MemToReg, ALU_to_Mux_signal, DataMem_to_Mux_signal, busW_signal);
	
	--busB Mux
	MUX_RegToALU : mux_32 port map(ALU_src, busB_signal, extender_to_Mux_signal, RegMux_to_ALU_signal);
	
	--Register destination Mux
	-- Mux_RegDst : mux_n 
		-- generic map(n => 5)
		-- port map(RegDst, Rt, Rd, Rw_signal);
		
	--Extender component
	Extender : extender port map(imm16, extender_to_Mux_signal);
	
	--Register 32
	Register_file : register_component port map(
		clk => clk, 
		rst => '0',
		we => RegWr,
		busw => busW_signal,
		rd => Rd,
		rs => Rs,
		rt => Rt,
		busa => busA_signal,
		busb => busB_signal
	);
		
	
		
	
	
	
	


end datapath;