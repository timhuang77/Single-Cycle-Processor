library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity extender is 
	port (
		A	: in std_logic_vector(15 downto 0);
		R	: out std_logic_vector(31 downto 0)
	);
end entity extender;
	
architecture structural of extender is

begin 
	lower_half : for i in 0 to 15 generate
		R(i) <= A(i); 
	end generate lower_half;
	
	upper_half : for i in 16 to 31 generate
		R(i) <= A(15);
	end generate upper_half;
end structural;