-------------------------------------------------------------------------------
-- Copyright (c) 2019 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 13.4
--  \   \         Application: Xilinx CORE Generator
--  /   /         Filename   : vio.vho
-- /___/   /\     Timestamp  : Thu Oct 17 13:17:17 EDT 2019
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: ISE Instantiation template
-- Component Identifier: xilinx.com:ip:chipscope_vio:1.05.a
-------------------------------------------------------------------------------
-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component vio
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    ASYNC_OUT : OUT STD_LOGIC_VECTOR(26 DOWNTO 0));

end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG

your_instance_name : vio
  port map (
    CONTROL => CONTROL,
    ASYNC_OUT => ASYNC_OUT);

-- INST_TAG_END ------ End INSTANTIATION Template ------------
