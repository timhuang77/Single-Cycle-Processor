library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity decoder is
	port (
		data   				: in  std_logic_vector(31 downto 0);
		opcode   			: out std_logic_vector(5 downto 0);
		rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
		funct   				: out std_logic_vector(5 downto 0);
		addr 					: out std_logic_vector(15 downto 0)
	);
end entity decoder;

architecture structural of decoder is
    
	begin

	-- read opcode
	G0 : for i in 0 to 5 generate
		opcode(i) <= data(i + 26);
	end generate G0;

	-- read rs, rt, rd, and shamt
	G1 : for i in 0 to 4 generate
		rs(i) 	<= data(i + 21);
		rt(i) 	<= data(i + 16);
		rd(i) 	<= data(i + 11);
		shamt(i) <= data(i + 6);
	end generate G1;

	-- read function
	G2 : for i in 0 to 5 generate
		funct(i) <= data(i);
	end generate G2;

	-- read address
	G3 : for i in 0 to 15 generate
		addr(i) 	<= data(i);
	end generate G3;

end architecture structural;
