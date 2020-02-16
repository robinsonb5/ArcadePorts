library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.rom_pkg.ALL;


entity VirtualToplevel is
	generic (
		sdram_rows : integer := 12;
		sdram_cols : integer := 8;
		sysclk_frequency : integer := 1000 -- Sysclk frequency * 10
	);
	port (
		hostclk : in std_logic;
		clk 			: in std_logic;
		reset_in 	: in std_logic;

		-- VGA
		vga_red 		: out unsigned(7 downto 0);
		vga_green 	: out unsigned(7 downto 0);
		vga_blue 	: out unsigned(7 downto 0);
		vga_hsync 	: out std_logic;
		vga_vsync 	: buffer std_logic;
		vga_window	: out std_logic;

		-- SDRAM
		sdr_data		: inout std_logic_vector(15 downto 0);
		sdr_addr		: out std_logic_vector((sdram_rows-1) downto 0);
		sdr_dqm 		: out std_logic_vector(1 downto 0);
		sdr_we 		: out std_logic;
		sdr_cas 		: out std_logic;
		sdr_ras 		: out std_logic;
		sdr_cs		: out std_logic;
		sdr_ba		: out std_logic_vector(1 downto 0);
		sdr_clk		: out std_logic;
		sdr_cke		: out std_logic;

		-- SPI signals
		spi_miso		: in std_logic := '1'; -- Allow the SPI interface not to be plumbed in.
		spi_mosi		: out std_logic;
		spi_clk		: out std_logic;
		spi_cs 		: out std_logic;
		
		-- PS/2 signals
		ps2k_clk_in : in std_logic := '1';
		ps2k_dat_in : in std_logic := '1';
		ps2k_clk_out : out std_logic;
		ps2k_dat_out : out std_logic;
		ps2m_clk_in : in std_logic := '1';
		ps2m_dat_in : in std_logic := '1';
		ps2m_clk_out : out std_logic;
		ps2m_dat_out : out std_logic;

		-- UART
		rxd	: in std_logic;
		txd	: out std_logic;
		
		-- Audio
		audio_l : out std_logic;
		audio_r : out std_logic
);
end entity;

architecture rtl of VirtualToplevel is

constant sysclk_hz : integer := sysclk_frequency*1000;
constant uart_divisor : integer := sysclk_hz/1152;
constant maxAddrBit : integer := 31;

signal reset_n : std_logic := '0';
signal reset_counter : unsigned(15 downto 0) := X"FFFF";

-- Millisecond counter
signal millisecond_counter : unsigned(31 downto 0) := X"00000000";
signal millisecond_tick : unsigned(19 downto 0);


-- SPI Clock counter
signal spi_tick : unsigned(8 downto 0);
signal spiclk_in : std_logic;
signal spi_fast : std_logic;

-- SPI signals
signal host_to_spi : std_logic_vector(7 downto 0);
signal spi_to_host : std_logic_vector(31 downto 0);
signal spi_wide : std_logic;
signal spi_trigger : std_logic;
signal spi_busy : std_logic;
signal spi_active : std_logic;

signal spi_chipselects : std_logic_vector(7 downto 0);
signal spi_fromguest_sd : std_logic;
signal spi_fromguest : std_logic;
signal spi_toguest : std_logic;
signal spi_clk_int : std_logic;
signal spi_ss2 : std_logic;
signal spi_ss3 : std_logic;
signal spi_ss4 : std_logic;
signal conf_data0 : std_logic;


-- UART signals

signal ser_txdata : std_logic_vector(7 downto 0);
signal ser_txready : std_logic;
signal ser_rxdata : std_logic_vector(7 downto 0);
signal ser_rxrecv : std_logic;
signal ser_txgo : std_logic;
signal ser_rxint : std_logic;


-- Interrupt signals

constant int_max : integer := 2;
signal int_triggers : std_logic_vector(int_max downto 0);
signal int_status : std_logic_vector(int_max downto 0);
signal int_ack : std_logic;
signal int_req : std_logic;
signal int_enabled : std_logic :='0'; -- Disabled by default
signal int_trigger : std_logic;


-- Timer register block signals

signal timer_reg_req : std_logic;
signal timer_tick : std_logic;


-- PS2 signals
signal ps2_int : std_logic;

signal kbdidle : std_logic;
signal kbdrecv : std_logic;
signal kbdrecvreg : std_logic;
signal kbdsendbusy : std_logic;
signal kbdsendtrigger : std_logic;
signal kbdsenddone : std_logic;
signal kbdsendbyte : std_logic_vector(7 downto 0);
signal kbdrecvbyte : std_logic_vector(10 downto 0);

signal mouseidle : std_logic;
signal mouserecv : std_logic;
signal mouserecvreg : std_logic;
signal mousesendbusy : std_logic;
signal mousesenddone : std_logic;
signal mousesendtrigger : std_logic;
signal mousesendbyte : std_logic_vector(7 downto 0);
signal mouserecvbyte : std_logic_vector(10 downto 0);


-- Plumbing between DMA controller and SDRAM

signal vga_addr : std_logic_vector(31 downto 0);
signal vga_data : std_logic_vector(15 downto 0);
signal vga_req : std_logic;
signal vga_fill : std_logic;
signal vga_refresh : std_logic;
signal vga_reservebank : std_logic; -- Keep bank clear for instant access.
signal vga_reserveaddr : std_logic_vector(31 downto 0); -- to SDRAM

signal dma_data : std_logic_vector(15 downto 0);


-- CPU signals

signal soft_reset_n : std_logic;
signal mem_busy : std_logic;
signal mem_rom : std_logic;
signal rom_ack : std_logic;
signal from_mem : std_logic_vector(31 downto 0);
signal cpu_addr : std_logic_vector(31 downto 0);
signal to_cpu : std_logic_vector(31 downto 0);
signal from_cpu : std_logic_vector(31 downto 0);
signal cpu_req : std_logic; 
signal cpu_ack : std_logic; 
signal cpu_wr : std_logic; 
signal cpu_bytesel : std_logic_vector(3 downto 0);
signal mem_rd : std_logic; 
signal mem_wr : std_logic; 
signal mem_rd_d : std_logic; 
signal mem_wr_d : std_logic; 
signal cache_valid : std_logic;
signal flushcaches : std_logic;

signal to_rom : ToROM;
signal from_rom : FromROM;

COMPONENT MCR3Mono_MiST
	PORT
	(
		LED		:	 OUT STD_LOGIC;
		VGA_R		:	 OUT unsigned(5 DOWNTO 0);
		VGA_G		:	 OUT unsigned(5 DOWNTO 0);
		VGA_B		:	 OUT unsigned(5 DOWNTO 0);
		VGA_HS		:	 OUT STD_LOGIC;
		VGA_VS		:	 OUT STD_LOGIC;
		AUDIO_L		:	 OUT STD_LOGIC;
		AUDIO_R		:	 OUT STD_LOGIC;
		SPI_SCK		:	 IN STD_LOGIC;
		SPI_DO		:	 INOUT STD_LOGIC;
		SPI_DI		:	 IN STD_LOGIC;
		SPI_SS2		:	 IN STD_LOGIC;
		SPI_SS3		:	 IN STD_LOGIC;
		SPI_SS4		:	 IN STD_LOGIC;
		CONF_DATA0		:	 IN STD_LOGIC;
		CLOCK_27		:	 IN STD_LOGIC;
		SDRAM_A		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		SDRAM_DQ		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		SDRAM_DQML		:	 OUT STD_LOGIC;
		SDRAM_DQMH		:	 OUT STD_LOGIC;
		SDRAM_nWE		:	 OUT STD_LOGIC;
		SDRAM_nCAS		:	 OUT STD_LOGIC;
		SDRAM_nRAS		:	 OUT STD_LOGIC;
		SDRAM_nCS		:	 OUT STD_LOGIC;
		SDRAM_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		SDRAM_CLK		:	 OUT STD_LOGIC;
		SDRAM_CKE		:	 OUT STD_LOGIC
	);
END COMPONENT;


begin

-- Reset counter.

process(clk)
begin
	if reset_in='0' then -- or sdr_ready='0' then
		reset_counter<=X"FFFF";
		reset_n<='0';
	elsif rising_edge(clk) then
		reset_counter<=reset_counter-1;
		if reset_counter=X"0000" then
			reset_n<='1';
		end if;
	end if;
end process;


-- Timer
process(clk)
begin
	if rising_edge(clk) then
		millisecond_tick<=millisecond_tick+1;
		if millisecond_tick=sysclk_frequency*100 then
			millisecond_counter<=millisecond_counter+1;
			millisecond_tick<=X"00000";
		end if;
	end if;
end process;



-- UART

myuart : entity work.simple_uart
	generic map(
		enable_tx=>true,
		enable_rx=>true
	)
	port map(
		clk => clk,
		reset => reset_n, -- active low
		txdata => ser_txdata,
		txready => ser_txready,
		txgo => ser_txgo,
		rxdata => ser_rxdata,
		rxint => ser_rxint,
		txint => open,
		clock_divisor => to_unsigned(uart_divisor,16),
		rxd => rxd,
		txd => txd
	);

-- PS2 devices

	mykeyboard : entity work.io_ps2_com
		generic map (
			clockFilter => 15,
			ticksPerUsec => sysclk_frequency/10
		)
		port map (
			clk => clk,
			reset => not reset_n, -- active high!
			ps2_clk_in => ps2k_clk_in,
			ps2_dat_in => ps2k_dat_in,
			ps2_clk_out => ps2k_clk_out,
			ps2_dat_out => ps2k_dat_out,
			
			inIdle => open,	-- Probably don't need this
			sendTrigger => kbdsendtrigger,
			sendByte => kbdsendbyte,
			sendBusy => kbdsendbusy,
			sendDone => kbdsenddone,
			recvTrigger => kbdrecv,
			recvByte => kbdrecvbyte
		);


	mymouse : entity work.io_ps2_com
		generic map (
			clockFilter => 15,
			ticksPerUsec => sysclk_frequency/10
		)
		port map (
			clk => clk,
			reset => not reset_n, -- active high!
			ps2_clk_in => ps2m_clk_in,
			ps2_dat_in => ps2m_dat_in,
			ps2_clk_out => ps2m_clk_out,
			ps2_dat_out => ps2m_dat_out,
			
			inIdle => open,	-- Probably don't need this
			sendTrigger => mousesendtrigger,
			sendByte => mousesendbyte,
			sendBusy => mousesendbusy,
			sendDone => mousesenddone,
			recvTrigger => mouserecv,
			recvByte => mouserecvbyte
		);


-- SPI Timer
process(clk)
begin
	if rising_edge(clk) then
		spiclk_in<='0';
		spi_tick<=spi_tick+1;
		if (spi_fast='1' and spi_tick(4)='1') or spi_tick(7)='1' then
			spiclk_in<='1'; -- Momentary pulse for SPI host.
			spi_tick<='0'&X"00";
		end if;
	end if;
end process;


-- SPI host
spi : entity work.spi_interface
	port map(
		sysclk => clk,
		reset => reset_n,

		-- Host interface
		spiclk_in => spiclk_in,
		host_to_spi => host_to_spi,
		spi_to_host => spi_to_host,
		trigger => spi_trigger,
		busy => spi_busy,

		-- Hardware interface
--		miso => spi_miso,
--		mosi => spi_mosi,
--		spiclk_out => spi_clk
		miso => spi_fromguest_sd,
		mosi => spi_toguest,
		spiclk_out => spi_clk_int
	);

	
mytimer : entity work.timer_controller
  generic map(
		prescale => sysclk_frequency, -- Prescale incoming clock
		timers => 0
  )
  port map (
		clk => clk,
		reset => reset_n,

		reg_addr_in => cpu_addr(7 downto 0),
		reg_data_in => from_cpu,
		reg_rw => '0', -- we never read from the timers
		reg_req => timer_reg_req,

		ticks(0) => timer_tick -- Tick signal is used to trigger an interrupt
	);


-- Interrupt controller

intcontroller: entity work.interrupt_controller
generic map (
	max_int => int_max
)
port map (
	clk => clk,
	reset_n => reset_n and soft_reset_n,
	trigger => int_triggers, -- Again, thanks ISE.
	ack => int_ack,
	int => int_req,
	status => int_status
);

int_triggers<=(0=>timer_tick, 1=>ps2_int, others => '0');


-- ROM

	rom : entity work.MiSTWrapper_rom
	generic map(
		maxAddrBitBRAM => 12
	)
	port map(
		clk => clk,
		from_soc => to_rom,
		to_soc => from_rom
	);


-- Main CPU

	mem_rom <='1' when cpu_addr(31 downto 26)=X"0"&"00" else '0';
	mem_rd<='1' when cpu_req='1' and cpu_wr='0' and mem_rom='0' else '0';
	mem_wr<='1' when cpu_req='1' and cpu_wr='1' and mem_rom='0' else '0';

	to_rom.MemAAddr<=cpu_addr(15 downto 2);
	to_rom.MemAWrite<=from_cpu;
	to_rom.MemAByteSel<=cpu_bytesel;
		
	process(clk)
	begin
		if rising_edge(clk) then
			rom_ack<=cpu_req and mem_rom;

			if mem_rom='1' then
				to_cpu<=from_rom.MemARead;
			else
				to_cpu<=from_mem;
			end if;

			if (mem_busy='0' or rom_ack='1') and cpu_ack='0' then
				cpu_ack<='1';
			else
				cpu_ack<='0';
			end if;

			if mem_rom='1' then
				to_rom.MemAWriteEnable<=(cpu_wr and cpu_req);
			else
				to_rom.MemAWriteEnable<='0';
			end if;
	
		end if;	
	end process;
	
	cpu : entity work.eightthirtytwo_cpu
	generic map
	(
		littleendian => true,
		dualthread => false,
		prefetch => true,
		interrupts => true
	)
	port map
	(
		clk => clk,
		reset_n => reset_n and soft_reset_n,
		interrupt => int_req and int_enabled,

		-- cpu fetch interface

		addr => cpu_addr(31 downto 2),
		d => to_cpu,
		q => from_cpu,
		bytesel => cpu_bytesel,
		wr => cpu_wr,
		req => cpu_req,
		ack => cpu_ack
	);



process(clk)
begin
	if reset_n='0' then
		spi_active<='0';
		int_enabled<='0';
		kbdrecvreg <='0';
		mouserecvreg <='0';
		spi_cs <= '1';
		spi_ss2 <= '1';
		spi_ss3 <= '1';
		spi_ss4 <= '1';
		conf_data0 <= '1';
	elsif rising_edge(clk) then
		mem_busy<='1';
		ser_txgo<='0';
		int_ack<='0';
		timer_reg_req<='0';
		spi_trigger<='0';
		kbdsendtrigger<='0';
		mousesendtrigger<='0';
		flushcaches<='0';
		soft_reset_n<='1';
		
		mem_rd_d<=mem_rd;
		mem_wr_d<=mem_wr;

		-- Write from CPU?
		if mem_wr='1' and mem_wr_d='0' and mem_busy='1' then
			case cpu_addr(31)&cpu_addr(10 downto 8) is

				when X"C" =>	-- Timer controller at 0xFFFFFC00
					timer_reg_req<='1';
					mem_busy<='0';	-- Audio controller never blocks the CPU

				when X"F" =>	-- Peripherals
					case cpu_addr(7 downto 0) is

						when X"B0" => -- Interrupts
							int_enabled<=from_cpu(0);
							mem_busy<='0';
							
						when X"B4" => -- Cache control
							flushcaches<=from_cpu(0);
							mem_busy<='0';

						when X"C0" => -- UART
							ser_txdata<=from_cpu(7 downto 0);
							ser_txgo<='1';
							mem_busy<='0';

						when X"D0" => -- SPI CS
							if from_cpu(1)='1' then
								spi_cs <= not from_cpu(0);
							end if;
							if from_cpu(2)='1' then
								spi_ss2 <= not from_cpu(0);
							end if;
							if from_cpu(3)='1' then
								spi_ss3 <= not from_cpu(0);
							end if;
							if from_cpu(4)='1' then
								spi_ss4 <= not from_cpu(0);
							end if;
							if from_cpu(5)='1' then
								conf_data0 <= not from_cpu(0);
							end if;
							spi_fast<=from_cpu(8);
							mem_busy<='0';

						when X"D4" => -- SPI Data
							spi_wide<='0';
							spi_trigger<='1';
							host_to_spi<=from_cpu(7 downto 0);
							spi_active<='1';
						
						when X"D8" => -- SPI Pump (32-bit read)
							spi_wide<='1';
							spi_trigger<='1';
							host_to_spi<=from_cpu(7 downto 0);
							spi_active<='1';

						-- Write to PS/2 registers
						when X"e0" =>
							kbdsendbyte<=from_cpu(7 downto 0);
							kbdsendtrigger<='1';
							mem_busy<='0';

						when X"e4" =>
							mousesendbyte<=from_cpu(7 downto 0);
							mousesendtrigger<='1';
							mem_busy<='0';

						when others =>
							mem_busy<='0';
							null;
					end case;
				when others =>
					mem_busy<='0';
--					sdram_addr<=cpu_addr;
--					sdram_bytesel<=cpu_bytesel;
--					sdram_wr<='0';
--					sdram_req<='1';
--					sdram_write<=from_cpu;
--					sdram_state<=read1;	-- read/write logic doesn't need to differ.
			end case;

		elsif mem_rd='1' and mem_rd_d='0' and mem_busy='1' then -- Read from CPU?
			case cpu_addr(31 downto 28) is

				when X"F" =>	-- Peripherals
					case cpu_addr(7 downto 0) is

						when X"B0" => -- Interrupt
							from_mem<=(others=>'X');
							from_mem(int_max downto 0)<=int_status;
							int_ack<='1';
							mem_busy<='0';

						when X"C0" => -- UART
							from_mem<=(others=>'X');
							from_mem(9 downto 0)<=ser_rxrecv&ser_txready&ser_rxdata;
							ser_rxrecv<='0';	-- Clear rx flag.
							mem_busy<='0';
							
						when X"C8" => -- Millisecond counter
							from_mem<=std_logic_vector(millisecond_counter);
							mem_busy<='0';

						when X"D0" => -- SPI Status
							from_mem<=(others=>'X');
							from_mem(15)<=spi_busy;
							mem_busy<='0';

						when X"D4" => -- SPI read (blocking)
							spi_active<='1';

						when X"D8" => -- SPI wide read (blocking)
							spi_wide<='1';
							spi_trigger<='1';
							spi_active<='1';
							host_to_spi<=X"FF";

						-- Read from PS/2 regs
						when X"E0" =>
							from_mem<=(others =>'0');
							from_mem(11 downto 0)<=kbdrecvreg & not kbdsendbusy & kbdrecvbyte(10 downto 1);
							kbdrecvreg<='0';
							mem_busy<='0';
							
						when X"E4" =>
							from_mem<=(others =>'0');
							from_mem(11 downto 0)<=mouserecvreg & not mousesendbusy & mouserecvbyte(10 downto 1);
							mouserecvreg<='0';
							mem_busy<='0';

						when others =>
							mem_busy<='0';
					end case;

				when others =>
					mem_busy<='0';
--					sdram_addr<=cpu_addr;
--					sdram_addr(1 downto 0)<="00";
--					sdram_wr<='1';
--					sdram_req<='1';
--					sdram_state<=read1;
			end case;
		end if;

	-- SDRAM state machine
	
--		case sdram_state is
--			when read1 => -- read first word from RAM
--				if sdram_ack='0' or cache_valid='1' then
--					-- Endian mangling for SDRAM
--					from_mem(7 downto 0)<=sdram_read(31 downto 24);
--					from_mem(15 downto 8)<=sdram_read(23 downto 16);
--					from_mem(23 downto 16)<=sdram_read(15 downto 8);
--					from_mem(31 downto 24)<=sdram_read(7 downto 0);
--					sdram_req<='0';
--					sdram_state<=idle;
--					mem_busy<='0';
--				end if;
--			when others =>
--				null;
--
--		end case;


		-- SPI cycles

		if spi_active='1' and spi_busy='0' then
			from_mem<=spi_to_host;
			spi_active<='0';
			mem_busy<='0';
		end if;


		-- Set this after the read operation has potentially cleared it.
		if ser_rxint='1' then
			ser_rxrecv<='1';
			if ser_rxdata=X"04" then
				soft_reset_n<='0';
				ser_rxrecv<='0';
				int_enabled<='0';
			end if;
		end if;

		-- PS2 interrupt
		ps2_int <= kbdrecv or kbdsenddone
			or mouserecv or mousesenddone;
			-- mouserecv or kbdsenddone or mousesenddone ; -- Momentary high pulses to indicate retrieved data.
		if kbdrecv='1' then
			kbdrecvreg <= '1'; -- remains high until cleared by a read
		end if;
		if mouserecv='1' then
			mouserecvreg <= '1'; -- remains high until cleared by a read
		end if;	

	end if; -- rising-edge(clk)

end process;


guest: COMPONENT MCR3Mono_MiST
	PORT map
	(
		CLOCK_27 => hostclk,
		SDRAM_DQ => sdr_data,
		SDRAM_A => sdr_addr,
		SDRAM_DQML => sdr_dqm(0),
		SDRAM_DQMH => sdr_dqm(1),
		SDRAM_nWE => sdr_we,
		SDRAM_nCAS => sdr_cas,
		SDRAM_nRAS => sdr_ras,
		SDRAM_nCS => sdr_cs,
		SDRAM_BA => sdr_ba,
		SDRAM_CLK => sdr_clk,
		SDRAM_CKE => sdr_cke,
		
		SPI_DO => spi_fromguest,
		SPI_DI => spi_toguest,
		SPI_SCK => spi_clk_int,
		SPI_SS2	=> spi_ss2,
		SPI_SS3 => spi_ss3,
		SPI_SS4	=> spi_ss4,
		
		CONF_DATA0 => conf_data0,

		VGA_HS => vga_hsync,
		VGA_VS => vga_vsync,
		VGA_R => vga_red(7 downto 2),
		VGA_G => vga_green(7 downto 2),
		VGA_B => vga_blue(7 downto 2)
);

spi_fromguest_sd <= spi_miso when conf_data0='1' else spi_fromguest;
spi_mosi <= spi_toguest;
spi_clk <= spi_clk_int;
	
end architecture;
