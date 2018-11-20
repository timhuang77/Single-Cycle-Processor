library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity fulladder_32 is
	generic (
		n	: integer;
	);
	port (
		A, B 	: in std_logic_vector(n - 1 downto 0);
		R		: out std_logic_vector(n - 1 downto 0)
	);
end fulladder_32;

architecture structural of fulladder_32 is

	component fulladder_1 is
		port ( 
			x, y, cin	: in std_logic;
			z, cout		: out std_logic
		);
	end component fulladder_1;

	signal cin_cout : std_logic_vector(n downto 0);
	
	begin
		cin_cout(0) <= '0';
		gen_adder : for i in (0 to n - 1) generate
			add_map : fulladder_1 port map (x => A(i), y => B(i), cin => cin_cout(i), cout => cin_cout(i + 1), z => R(i));
		end generate gen_adder;
		
end architecture structural;