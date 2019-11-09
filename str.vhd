----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:44:23 10/21/2019 
-- Design Name: 
-- Module Name:    strobe - Behavioral 
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

entity str is
    Port ( clk : in  STD_LOGIC;
				enable: in STD_LOGIC;
           strb: out  STD_LOGIC);
end str;

architecture Behavioral of str is
begin

process(clk)
	variable change_clk: std_ulogic := '0';
		begin
			if rising_edge(clk) and enable = '1' then
				if change_clk = '1' then
					change_clk := '0';
				else
					change_clk := '1';
				end if;
			strb <= not change_clk;
			end if;
end process;


end Behavioral;
