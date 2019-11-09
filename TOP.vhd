----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:26:22 10/28/2019 
-- Design Name: 
-- Module Name:    TOP - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
Port ( 
	clk: in STD_LOGIC 
	);
end TOP;

architecture Behavioral of TOP is

	COMPONENT CPU_gen
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		trig : IN std_logic;          
		Address : OUT std_logic_vector(15 downto 0);
		wr_rd : OUT std_logic;
		cs : OUT std_logic;
		DOut : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT cache_control
	PORT(
		addr_in : IN std_logic_vector(15 downto 0);
		wr_in : IN std_logic;
		cs_in : IN std_logic;
		clk : IN std_logic;
		data_in_cpu : IN std_logic_vector(7 downto 0);
		data_in_sdram : IN std_logic_vector(7 downto 0);          
		addr_out : OUT std_logic_vector(15 downto 0);
		wr_out : OUT std_logic;
		mstrb : OUT std_logic;
		data_out_sdram : OUT std_logic_vector(7 downto 0);
		data_out_cpu : OUT std_logic_vector(7 downto 0);
		ready_out : OUT std_logic
		);
	END COMPONENT;

	COMPONENT sdram_controller
	PORT(
		sdram_addr_in : IN std_logic_vector(15 downto 0);
		sdram_wr_rd_in : IN std_logic;
		sdram_mstrb : IN std_logic;
		sdram_din : IN std_logic_vector(7 downto 0);          
		sdram_dout : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal addr_cpu_cache : std_logic_vector(15 downto 0);
	signal wr_rd_cpu_cache : std_logic;
	signal cs_cpu_cache : std_logic;
	signal dout_cpu_cache : std_logic_vector(7 downto 0);
	signal ready_cache_sdram : std_logic;
	signal addr_cache_sdram : std_logic_vector(15 downto 0);
	signal wr_rd_cache_sdram : std_logic;
	signal mstrb_cache_sdram : std_logic;
	signal din_cache_sdram : std_logic_vector(7 downto 0);
	signal din_cache_cpu : std_logic_vector(7 downto 0);
	signal dout_sdram_cache : std_logic_vector(7 downto 0);


begin

	Inst_CPU_gen: CPU_gen PORT MAP(
		clk => clk,
		rst => '0',
		trig => ready_cache_sdram,
		Address => addr_cpu_cache,
		wr_rd => wr_rd_cpu_cache,
		cs => cs_cpu_cache,
		DOut => dout_cpu_cache
	);

	Inst_cache_control: cache_control PORT MAP(
		addr_in => addr_cpu_cache,
		wr_in => wr_rd_cpu_cache,
		cs_in => cs_cpu_cache,
		clk => clk,
		data_in_cpu => dout_cpu_cache,
		data_in_sdram => dout_sdram_cache,
		addr_out => addr_cache_sdram,
		wr_out => wr_rd_cache_sdram,
		mstrb => mstrb_cache_sdram,
		data_out_sdram => din_cache_sdram,
		data_out_cpu => din_cache_cpu,
		ready_out => ready_cache_sdram
	);

	Inst_sdram_controller: sdram_controller PORT MAP(
		sdram_addr_in => addr_cache_sdram,
		sdram_wr_rd_in => wr_rd_cache_sdram,
		sdram_mstrb => mstrb_cache_sdram,
		sdram_din => din_cache_sdram,
		sdram_dout => dout_sdram_cache
	);

end Behavioral;

