library ieee;
use ieee.std_logic_1164.all;

entity decoder_tb is
	port (
		opcode				: out std_logic_vector(5 downto 0);
		rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
		funct   				: out std_logic_vector(5 downto 0);
		addr	 				: out std_logic_vector(15 downto 0)
	);
end decoder_tb;

architecture structural of decoder_tb is

	component decoder is
		port (
			data   				: in  std_logic_vector(31 downto 0);
			opcode   			: out std_logic_vector(5 downto 0);
			rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
			funct   				: out std_logic_vector(5 downto 0);
			addr 					: out std_logic_vector(15 downto 0)
		);
	end component decoder;

	signal data : std_logic_vector(31 downto 0);

	begin
	
	decoder_map : decoder port map (data, opcode, rs, rt, rd, shamt, funct, addr);
	
	test : process
	begin
		-- add $s3, $s2, $s1
		data <= "00000000001000100001100000100000";
		wait for 5 ns;

		-- sub $s3, $s2, $s1
		data <= "00000000001000100001100000100010";
		wait for 5 ns;
		
		wait;
	end process;
	
end architecture structural;