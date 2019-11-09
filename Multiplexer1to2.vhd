----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:21:12 10/16/2019 
-- Design Name: 
-- Module Name:    Multiplexer1to2 - Behavioral 
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

entity Multiplexer1to2 is
    Port ( w : in  STD_LOGIC_VECTOR (7 downto 0);
           s : in  STD_LOGIC;
           f1 : out  STD_LOGIC_VECTOR (7 downto 0);
           f2 : out  STD_LOGIC_VECTOR (7 downto 0));
end Multiplexer1to2;

architecture Behavioral of Multiplexer1to2 is

begin

	PROCESS(s)
	BEGIN
	if s = '0' then
		f1<= w;
		f2<= x"00";
	elsif s = '1' then
		f1<= x"00";
		f2<= w;
	end if;
	END PROCESS;
	
end Behavioral;

