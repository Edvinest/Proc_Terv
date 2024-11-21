#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2023.2.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : AMD Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Wed Nov 20 17:01:55 EET 2024
# SW Build 4126759 on Thu Feb  8 23:52:05 MST 2024
#
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot Top_Level_Test_behav xil_defaultlib.Top_Level_Test -log elaborate.log"
xelab --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot Top_Level_Test_behav xil_defaultlib.Top_Level_Test -log elaborate.log

