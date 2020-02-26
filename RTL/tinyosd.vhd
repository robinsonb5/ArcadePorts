library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- TinyOnScreenDisplay module - 
-- provides an on-screen display without using blockram
-- either for character ROM or text buffer.
-- Works by displaying a very simple bitmapped graphic.
-- Registers:
-- 0 - enable
-- 4 - colour
-- 8 - row 1
-- 12 - row 2
-- 16 - row 3
-- 20 - row 4
-- 24 - row 5


entity TinyOSD is
generic (
	hsync_polarity : std_logic := '1';
	vsync_polarity : std_logic := '1';
	hstart : integer := 35;
	vstart : integer := 50;
	pixelclock : integer := 7
);
port(
	reset_n : in std_logic;
	clk : in std_logic;
	-- Video
	hsync_n : in std_logic;
	vsync_n : in std_logic;
	enabled : out std_logic;
	pixel : out std_logic;
	window : out std_logic;
	colour : out std_logic_vector(5 downto 0);
	-- Registers
	a : in std_logic_vector(4 downto 0);
	d : in std_logic_vector(31 downto 0);
	wr : in std_logic
);
end entity;

architecture rtl of TinyOSD is

constant osdwidth : integer :=24;
constant osdheight : integer :=5;

signal hsync_p : std_logic; -- Previous state
signal vsync_p : std_logic; -- Previous state
signal newline : std_logic;

-- Pixel clock generation

signal pixelcounter : unsigned(3 downto 0);
signal pix : std_logic; -- Triggered momentarily at a pixel boundary

-- Pixel-clock-based signals
signal xpixelpos : signed(11 downto 0);
signal ypixelpos : signed(8 downto 0);
signal hwindowactive : std_logic;
signal vwindowactive : std_logic;
signal hactive : std_logic;
signal vactive : std_logic;

-- Registers 
signal osd_enable : std_logic;
signal row : unsigned(2 downto 0);
signal row1 : std_logic_vector(23 downto 0);
signal row2 : std_logic_vector(23 downto 0);
signal row3 : std_logic_vector(23 downto 0);
signal row4 : std_logic_vector(23 downto 0);
signal row5 : std_logic_vector(23 downto 0);
signal shifter : std_logic_vector(23 downto 0);

begin

enabled<=osd_enable;

-- Monitor hsync and count the pulse widths

process(clk,hsync_n,vsync_n)
begin
	if rising_edge(clk) then
		hsync_p<=hsync_n;
		newline<='0';
		
		if hsync_n=hsync_polarity and hsync_p/=hsync_polarity then -- rising edge?
			newline<='1'; -- New line starts here if polarity is reversed
		end if;		

	end if;
end process;


-- Monitor newline and count the vsync pulses

process(clk,hsync_n)
begin
	if rising_edge(clk) then
		if newline='1' then
			vsync_p<=vsync_n;

			ypixelpos<=ypixelpos+1;

			if vsync_n=vsync_polarity and vsync_p/=vsync_polarity then -- rising edge?
				ypixelpos<=to_signed(-vstart,ypixelpos'length);
			end if;

		end if;
	end if;
end process;


-- Increment pixel counter and generate pixel pulse.

process(clk)
begin
	if rising_edge(clk) then
		if pixelcounter=pixelclock or newline='1' then
			pixelcounter<="0000";
			pix<='1';
		else
			pixelcounter<=pixelcounter+1;
			pix<='0';
		end if;
	end if;
end process;


process(clk,a,d)
begin

	if reset_n='0' then
		osd_enable<='0';
	elsif rising_edge(clk) then
		if wr='1' then -- write
			case a is
				when "00000" =>
					osd_enable<=d(0);
				when "00100" =>
					colour<=d(5 downto 0);
				when "01000" =>
					row1<=d(23 downto 0);
				when "01100" =>
					row2<=d(23 downto 0);
				when "10000" =>
					row3<=d(23 downto 0);
				when "10100" =>
					row4<=d(23 downto 0);
				when "11000" =>
					row5<=d(23 downto 0);
				when others =>
					null;
			end case;
		end if;
	end if;
end process;


-- Generate window signal

-- Enable vactive for ypixel positions between 0 and 10, inclusive.
vactive<='1' when ypixelpos>0 and ypixelpos<(2*osdheight)+4 else '0';
-- Enable hactive for xpixel positions between 0 and 255, inclusive.
hactive<='1' when xpixelpos>=0 and xpixelpos<=osdwidth else '0';

process(clk)
begin

	window<=osd_enable and hwindowactive and vwindowactive;

	if rising_edge(clk) then

		if pix='1' then
			if xpixelpos = -4 then -- 4 pixel border
				hwindowactive<='1';
			end if;
			if xpixelpos = (osdwidth+4) then -- 4 pixel border
				hwindowactive<='0';
			end if;
			xpixelpos<=xpixelpos+1;
			if hactive='1' and vactive='1' then
				pixel<=shifter(0);
				shifter<='0'&shifter(shifter'high downto 1);
			end if;
		end if;
	
		if newline='1' then	-- Reset horizontal counter
			if ypixelpos=-4 then -- 4 pixel border
				vwindowactive<='1';
			end if;
			if ypixelpos=osdheight*2+1 then -- 4 pixel border
				vwindowactive<='0';
			end if;
			
			xpixelpos<=to_signed(-hstart,xpixelpos'length);
			
			case ypixelpos(8 downto 1) is
				when X"00" =>
					shifter<=row1;
				when X"01" =>
					shifter<=row2;
				when X"02" =>
					shifter<=row3;
				when X"03" =>
					shifter<=row4;
				when X"04" =>
					shifter<=row5;
				when others =>
					null;
			end case;
		end if;

	end if;
end process;

end architecture;
