library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity decoder is
	port (
		x : in std_logic_vector (4 downto 0);
		z : out std_logic_vector (31 downto 0)
	);
end entity decoder;

architecture structural of decoder is

	component and_n is
		generic (
			n : integer
		);
		port (
			x : in std_logic_vector(n - 1 downto 0);
			z : out std_logic
		);
	end component and_n;

	type concat_array_type is array (31 downto 0) of std_logic_vector(4 downto 0);
	signal concat_array : concat_array_type;
	
	signal  not_x : std_logic_vector(4 downto 0);
	
	begin
	
	-- invert input x
	invert_x: not_gate_n generic map(n => 5) port map(x=>x, z => not_x);
   
	--All of the and gates
	
	-- first bit
   concat_array(31) 	<= 	(x(4) & x(3) & x(2) & x(1) & x(0));
	concat_array(30) 	<=		(x(4) & x(3) & x(2) & x(1) & not_x(0));
	
	-- second bit
	concat_array(29) 	<= 	(x(4) & x(3) & x(2) & not_x(1) & x(0));
	concat_array(28) 	<= 	(x(4) & x(3) & x(2) & not_x(1) & not_x(0));
	
	-- third bit
	concat_array(27) 	<= 	(x(4) & x(3) & not_x(2) & x(1) & x(0));
	concat_array(26) 	<= 	(x(4) & x(3) & not_x(2) & x(1) & not_x(0));
	concat_array(25) 	<= 	(x(4) & x(3) & not_x(2) & not_x(1) & x(0));
	concat_array(24) 	<= 	(x(4) & x(3) & not_x(2) & not_x(1) & not_x(0));
	
	-- fourth bit
	concat_array(23) 	<= 	(x(4) & not_x(3) & x(2) & x(1) & x(0));
	concat_array(22) 	<= 	(x(4) & not_x(3) & x(2) & x(1) & not_x(0));
	concat_array(21) 	<= 	(x(4) & not_x(3) & x(2) & not_x(1) & x(0));
	concat_array(20) 	<= 	(x(4) & not_x(3) & x(2) & not_x(1) & not_x(0));
	concat_array(19) 	<= 	(x(4) & not_x(3) & not_x(2) & x(1) & x(0));
	concat_array(18) 	<= 	(x(4) & not_x(3) & not_x(2) & x(1) & not_x(0));
	concat_array(17) 	<= 	(x(4) & not_x(3) & not_x(2) & not_x(1) & x(0));
	concat_array(16) 	<= 	(x(4) & not_x(3) & not_x(2) & not_x(1) & not_x(0));
	
	-- fifth bit
	concat_array(15) 	<= 	(not_x(4) & x(3) & x(2) & x(1) & x(0));
	concat_array(14) 	<= 	(not_x(4) & x(3) & x(2) & x(1) & not_x(0));
	concat_array(13) 	<= 	(not_x(4) & x(3) & x(2) & not_x(1) & x(0));
	concat_array(12) 	<= 	(not_x(4) & x(3) & x(2) & not_x(1) & not_x(0));
	concat_array(11) 	<= 	(not_x(4) & x(3) & not_x(2) & x(1) & x(0));
	concat_array(10) 	<= 	(not_x(4) & x(3) & not_x(2) & x(1) & not_x(0));
	concat_array(9) 	<= 	(not_x(4) & x(3) & not_x(2) & not_x(1) & x(0));
	concat_array(8) 	<= 	(not_x(4) & x(3) & not_x(2) & not_x(1) & not_x(0));
	concat_array(7) 	<= 	(not_x(4) & not_x(3) & x(2) & x(1) & x(0));
	concat_array(6) 	<= 	(not_x(4) & not_x(3) & x(2) & x(1) & not_x(0));
	concat_array(5) 	<= 	(not_x(4) & not_x(3) & x(2) & not_x(1) & x(0));
	concat_array(4) 	<= 	(not_x(4) & not_x(3) & x(2) & not_x(1) & not_x(0));
	concat_array(3) 	<= 	(not_x(4) & not_x(3) & not_x(2) & x(1) & x(0));
	concat_array(2) 	<= 	(not_x(4) & not_x(3) & not_x(2) & x(1) & not_x(0));
	concat_array(1) 	<= 	(not_x(4) & not_x(3) & not_x(2) & not_x(1) & x(0));
	concat_array(0) 	<= 	(not_x(4) & not_x(3) & not_x(2) & not_x(1) & not_x(0));

	-- mapping the concatnated signals to and gates
	G0 : for i in 0 to 31 generate
		begin
			and5_map : and_n generic map (n => 5) port map (x => concat_array(i), z => z(i));
	end generate G0;
	
end architecture structural;