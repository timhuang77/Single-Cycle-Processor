library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity IFU is
	generic (
		mem	: string
	);
	
	port (
		clk, rst, beq, bneq, zero	: in std_logic;
		inst								: inout std_logic_vector(31 downto 0)
	);
end entity IFU;

architecture structural of IFU is
	signal PC_ff_in, PC_ff_out, PC_30, PC_4, imm_16_ext, PC_imm	: std_logic_vector(29 downto 0);
	signal PC_full, PC_dc	: std_logic_vector(31 downto 0);
	signal bz, nz, b, bnz	: std_logic;
	signal imm16				: std_logic_vector(15 downto 0);
	
	begin
	
		-- program counter storage in flip flops
		gen_ff : for i in (0 to 29) generate
			dff_PC : dff port map(clk => clk, d => PC_ff_in(i), q => PC_ff_out(i));
		end generate gen_ff;
		
		-- PC + 4
		add_4_PC 	: fulladder_32 generic map (n => 30) port map (A => PC_ff_out, B => "000000000000000000000000000001", R => PC_4);
		
		-- sign extend Imm16
		ext_imm		: extender generic map (n => 16, m => 30) port map (A => imm16, R => imm_16_ext);
		
		-- PC + 4 + signextend(Imm16)
		add_imm_PC 	: fulladder_32 generic map(n => 30) port map (A => PC_4, B => imm_16_ext, R => PC_imm);
		
		-- branch zero
		and_bz		: and_gate port map (x => beq, y => zero, z => bz);
		
		-- branch not zero
		not_z			: not_gate port map (zero, nz);
		and_bnz		: and_gate port map (x => bneq, y => nz, z => bnz);
		
		-- mux PC+4 or PC+4+Imm16
		or_branches	: or_gate port map (bz, bnz, b);
		PC_mux		: mux_n generic map (n => 30) port map (sel => b, src0 => PC_4, src1 => PC_imm, z => PC_30);
		
		-- choose PC_30 or the start address
		mux_res		: mux_n generic map (n => 30) port map (sel => rst, src0 => PC_30, src1 => "000000000100000000000000001000", z => PC_ff_in);
		
		-- create full instruction address
		PC_full 	<= PC_ff_out & "00";
		
		-- get next instruction from sram
		PC_dc 	<= "00000000000000000000000000000000";
		insMem_map 	: syncram generic map (mem_file => mem) port map (clk => clk, cs => '1', oe => '1', we => '0', addr => PC_full, din => PC_dc, dout => inst);
		
		-- get Imm16
		imm16 	<= inst(15 downto 0);
		
end architecture structural;
		
		
		
	