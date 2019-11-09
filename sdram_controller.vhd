----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:51:21 10/29/2019 
-- Design Name: 
-- Module Name:    SDRAM_CONTROL - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdram_controller is
    Port ( sdram_addr_in : in  STD_LOGIC_VECTOR (15 downto 0);
           sdram_wr_rd_in : in  STD_LOGIC;
           sdram_mstrb : in  STD_LOGIC;
           sdram_din : in  STD_LOGIC_VECTOR (7 downto 0);
           sdram_dout : out  STD_LOGIC_VECTOR (7 downto 0));
end sdram_controller;

architecture Behavioral of sdram_controller is

type storage_sdram is array (15 downto 0) of STD_LOGIC_VECTOR (7 DOWNTO 0);
signal Memory2: storage_sdram;

signal sdram_addr_in_sig :STD_LOGIC_VECTOR(15 DOWNTO 0);

begin


PROCESS(sdram_wr_rd_in,sdram_addr_in,sdram_din)

begin
sdram_addr_in_sig <= sdram_addr_in;

		if rising_edge(sdram_mstrb) then

			if sdram_wr_rd_in ='1' then
				Memory2(to_integer(unsigned(sdram_addr_in_sig))) <= sdram_din;	
			else
				sdram_dout<=Memory2(to_integer(unsigned(sdram_addr_in_sig)));			
			end if;
		end if;
		
end Process;

end Behavioral;

