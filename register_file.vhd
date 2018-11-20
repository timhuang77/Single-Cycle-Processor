library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity register_file is
	port (
		clk : in std_logic;
		rst : in std_logic;
		we : in std_logic;
		wd : in std_logic_vector(31 downto 0);
		read_A	: in std_logic_vector(4 down to 0);
		read_B	: in std_logic_vector(4 down to 0);
		write_index	: in std_logic_vector(4 down to 0);
		read_op_A	: out std_logic_vector(31 downto 0);
		read_op_B	: out std_logic_vector(31 downto 0)
	);
end entity register_file;

architecture structural of register_file is

	component decoder is
		port (
			x : in std_logic_vector (4 downto 0);
			z : out std_logic_vector (31 downto 0)
		);
	end component decoder;

	component mux_n_4 is
		generic (
			n : integer
		);
		port (
			sel 							: in std_logic_vector (1 downto 0);
			src0, src1, src2, src3	: in std_logic_vector (n - 1 downto 0);
			z								: out std_logic (n - 1 downto 0)
		);
	end component mux_n_4;
	
	entity component register_32bit is
		port (
			clk : in std_logic;
			rst : in std_logic;
			we : in std_logicl
			D : in std_logic_vector(31 downto 0);
			Z : out std_logic_vector(31 downto 0)
		);
	end component register_32bit;

	type reg_outs_type is array (0 to 31) of std_logic_vector(31 downto 0);
	type level1_out_type is array (0 to 7) of std_logic_vector(31 downto 0);
	type level2_out_type is array (0 to 7) of std_logic_vector(31 downto 0);
	
	signal reg_outs : reg_outs_type
	signal level1_out_A, level1_out_B : level1_out_type;
	signal level2_out_B, level2_out_B : level2_out_type;
	
	signal wes, decoded_we, we_32 : std_logic_vector(31 down to 0);
	
	begin
	
		decode_write_ad : decoder port map(x => write_index, z => decoded_we);
	
		we_32(31 downto 0) <= (31 downto 0 => we);
		
		and_we : and_gate_32 port map(x => decoded_we, y => we_32, z => wes);
		
		level1 : for i in (0 to 7) generate
			muxA : mux_n_4 generic map(n => 32) port map(sel => read_index_A(1 downto 0), src0 => reg_outs(i*4), src1 => reg_outs(i*4 + 1), src2 => reg_outs(i*4 + 2), src3 => reg_outs(i*4 + 3), z => level1_out_A(i));
			muxB : mux_n_4 generic map(n => 32) port map(sel => read_index_B(1 downto 0), src0 => reg_outs(i*4), src1 => reg_outs(i*4 + 1), src2 => reg_outs(i*4 + 2), src3 => reg_outs(i*4 + 3), z => level1_out_B(i));
		end generate level1;
		
		level2 : for i in (0 to 1) generate
			muxA_2 : mux_n_4 generic map(n => 32) port map(sel => read_index_A(3 downto 2), src0 => level1_out_A(i*4), src1 => level1_out_A(i*4 + 1), src2 => level1_out_A(i*4 + 2), src3 => level1_out_A(i*4 + 3), z => level2_out_A(i));
			muxB_2 : mux_n_4 generic map(n => 32) port map(sel => read_index_B(3 downto 2), src0 => level1_out_B(i*4), src1 => level1_out_B(i*4 + 1), src2 => level1_out_B(i*4 + 2), src3 => level1_out_B(i*4 + 3), z => level2_out_B(i));
		end generate level2;
		
		final_muxA : mux_32 port map(sel => read_index_A(4), src0 => level2_out_A(0), src1 => level2_out_A(1), z => read_op_A);
		final_muxB : mux_32 port map(sel => read_index_B(4), src0 => level2_out_B(0), src1 => level2_out_B(1), z => read_op_B);
		
		reg0 : register_32bit port map(clk => clk, rst => rst, we => '0', D => wd, Z => reg_outs(0));
		
		gen_regs : for i in (1 to 31) generate
			register_map : register_32bit port map (clk => clk, rst => rst, we => wes(i), D => wd, Z => reg_outs(i));
		end generate gen_regs;
end structural;