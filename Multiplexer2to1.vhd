----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:17:03 10/16/2019 
-- Design Name: 
-- Module Name:    Multiplexer2to1 - Behavioral 
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

entity Multiplexer2to1 is
    Port ( w0 : in  STD_LOGIC_VECTOR (7 downto 0);
           w1 : in  STD_LOGIC_VECTOR (7 downto 0);
           s : in  STD_LOGIC;
           f : out  STD_LOGIC_VECTOR (7 downto 0));
end Multiplexer2to1;

architecture Behavioral of Multiplexer2to1 is

begin

f <= w0 when s = '0' else w1;

end Behavioral;

