adder

.option post=2 *generate output waveform
.prot 
.lib  'cic018.l' tt *call library
.unprot
.global vdd gnd
*DC source
vvdd vdd 0  1.8
vgnd gnd 0  0

*   drain gate source body mos_type L 
.subckt adder a b c co  s vdd gnd 
mp0  net01   a  vdd  vdd  p_18  l=0.18u  w=8u
mp1  net01  b  vdd  vdd  p_18  l=0.18u  w=8u
mp2  net_mid  a  net02  vdd  p_18  l=0.18u  w=8u
mp3  net02    b  net01  vdd  p_18  l=0.18u  w=8u
mp4  net_mid  c  net01  vdd  p_18  l=0.18u  w=4u


mn0  net_mid  c  net03  0    n_18  l=0.18u  w=2u
mn1  net03    a  gnd    0    n_18  l=0.18u  w=2u
mn2  net03    b  gnd    0    n_18  l=0.18u  w=2u
mn3  net_mid  a  net04  0    n_18  l=0.18u  w=2u
mn4  net04    b  gnd    0    n_18  l=0.18u  w=2u

mp5  co   net_mid  vdd    vdd  p_18  l=0.18u  w=4u
mn5  co   net_mid  gnd    gnd  n_18  l=0.18u  w=2u

mp6   net05     a        vdd    vdd  p_18  l=0.18u  w=8u
mp7   net05     b        vdd    vdd  p_18  l=0.18u  w=8u
mp8   net05     c        vdd    vdd  p_18  l=0.18u  w=8u
mp9   net_mid2  net_mid  net05  vdd  p_18  l=0.18u  w=3u
mp10  net06     a        net05  vdd  p_18  l=0.18u  w=8u
mp11  net07     b        net06  vdd  p_18  l=0.18u  w=8u
mp12  net_mid2  c        net07  vdd  p_18  l=0.18u  w=8u
mn6   net_mid2   net_mid  net08    gnd  n_18  l=0.18u  w=2u
mn7   net08   a  gnd    gnd  n_18  l=0.18u  w=2u
mn8   net08   b  gnd    gnd  n_18  l=0.18u  w=2u
mn9   net08   c  gnd    gnd  n_18  l=0.18u  w=2u
mn10  net_mid2 a  net09  gnd  n_18  l=0.18u  w=3u
mn11  net09    b  net10  gnd  n_18  l=0.18u  w=3u
mn12  net10    c  gnd    gnd  n_18  l=0.18u  w=3u

mp13  s   net_mid2  vdd    vdd  p_18  l=0.18u  w=4u
mn13  s   net_mid2  gnd    gnd  n_18  l=0.18u  w=2u
.ends
xa1 a b c co s vdd gnd adder
*cload node+ node- value
cload1  co   gnd  0.1p 
cload2  s   gnd  0.1p 
*V  node+ node- pulse(V1  V2 T_delay T_rise T_fall pw    period)
va  a    gnd   pulse(1.8 0  0.1n   0.1n  0.1n  19.9n 40n)
vb  b    gnd   pulse(1.8 0  0.1n   0.1n  0.1n  39.9n 80n)
vc  c    gnd   pulse(1.8 0  0.1n   0.1n  0.1n  79.9n 160n)

*transient analysis:Time step is 0.1n ,stop time is 80n
.tran 0.05n 200n *sweep(k 0.05p 1p 0.05p) 
*(sweep k 0.5u 2u 0.5u)

*delay analysis val=half of vdd
.meas tran delay_co trig v(a)   val=0.9 rise=2
+                  targ v(co) val=0.9 rise=1

.meas tran delay_s trig v(a)   val=0.9 rise=1
+                  targ v(s) val=0.9 rise=1
*average_power analysis
.meas tran pw avg power

*power-Delay-Product(pdp) analysis
*.meas tran pdp=param('pw*delayN1')

.end

