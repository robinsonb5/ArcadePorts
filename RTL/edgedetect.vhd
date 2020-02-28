library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity edgedetect is
generic
(
	inputs : integer :=1
);
port
(
	clk : in std_logic;
	d : in std_logic_vector(inputs-1 downto 0);
	q : out std_logic
);
end entity;

architecture RTL of edgedetect is

signal d_d : std_logic_vector(inputs-1 downto 0);
signal init : std_logic := '0';
begin

	process(clk,d)
	begin
		if rising_edge(clk) then
			d_d<=d;
			q<='0';
			if init='0' then
				init<='1';
			elsif d=d_d then
				q<='1';
			end if;	
		end if;
	end process;

end architecture;