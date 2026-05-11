#######################
# Cross-section settings script for KLayout XSection (Ruby .xs)
# Converted from dummy_coupon.pyxs
# https://klayoutmatthias.github.io/xsection/
#######################

# NOTE: Process flow as in doc/Process review 10-11-2023_Almae_Updated.pdf

# Declare the basic accuracy used to remove artifacts for example: delta(5 * dbu)
delta(20 * dbu)
depth(8.0)
height(20.0)

# Sample technology values, modify them to match your particular technology

h_Si_trench = 2.0
h_SiO2 = 0.5
h_SiNx = 0.3
h_Coupon = 3.0
a_etch_si = 180 - 90 - 54.7
a_etch_sio2 = 2.5

################ stack ################
substrate = bulk
si = deposit(h_Si_trench + 4.0)
sio2 = deposit(h_SiO2)
sinx = deposit(h_SiNx)

# Step 1: Etch SiNx
l_ridge = layer("120/0")
l_ridge_etch = l_ridge.inverted
mask(l_ridge_etch).etch(h_SiNx, :taper => a_etch_sio2, :into => sinx)

# Step 1: Etch SiO2
l_trench = layer("121/0")
l_sio2_wet_etch = l_trench
mask(l_sio2_wet_etch).etch(h_SiO2, :taper => a_etch_sio2, :into => sio2)

# Step 2: Etch Si
mask(l_sio2_wet_etch).etch(h_Si_trench, :taper => a_etch_si, :into => si)

# Step 3: PR spin + etch
pr = deposit(h_Coupon, h_Coupon, :mode => :round)
l_coupon = layer("122/0")
l_coupon_etch = l_coupon.inverted
mask(l_coupon_etch).etch(h_Coupon, :into => pr)

# Out layers
output("300/0", si)
output("301/0", sio2)
output("302/1", sinx)
# output("303/0", bcb)
output("310/0", pr)
