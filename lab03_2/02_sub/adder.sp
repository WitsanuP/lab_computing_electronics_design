adder

.option post=2  *generate output waveform
.prot 
.lib  'cic018.l' tt *call library
.inc 'adder.spi'
.unprot
.global vdd gnd
*DC source
vvdd vdd 0  1.8
vgnd gnd 0  0

*.subckt adder8 a0 b0 a1 b2 a3 b3 a4 b4 a5 b5 a6 b6 a7 b7 
.subckt adder8 a0 a1 a2 a3 a4 a5 a6 a7
+              b0 b1 b2 b3 b4 b5 b6 b7 
+              s0 s1 s2 s3 s4 s5 s6 s7 s8 vdd gnd 
*.subckt adder a b c co  s vdd gnd 
xa0 a0 b0 gnd ci1 s0 vdd gnd adder
xa1 a1 b1 ci1 ci2 s1 vdd gnd adder
xa2 a2 b2 ci2 ci3 s2 vdd gnd adder
xa3 a3 b3 ci3 ci4 s3 vdd gnd adder
xa4 a4 b4 ci4 ci5 s4 vdd gnd adder
xa5 a5 b5 ci5 ci6 s5 vdd gnd adder
xa6 a6 b6 ci6 ci7 s6 vdd gnd adder
xa7 a7 b7 ci7 s8  s7 vdd gnd adder
.ends
xa1 a0 a1 a2 a3 a4 a5 a6 a7
+   b0 b1 b2 b3 b4 b5 b6 b7
+   s0 s1 s2 s3 s4 s5 s6 s7 s8  
+   vdd gnd adder8
*cload node+ node- value
cload1  s1   gnd  0.1p 
cload2  s2   gnd  0.1p 
cload3  s3   gnd  0.1p 
cload4  s4   gnd  0.1p 
cload5  s5   gnd  0.1p 
cload6  s6   gnd  0.1p 
cload7  s7   gnd  0.1p 
cload8  s7   gnd  0.1p 
*V  node+ node- pulse(V1  V2 T_delay T_rise T_fall pw    period)
va0  a0   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11000010)
va1  a1   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b01101111)
va2  a2   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b01001110)
va3  a3   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b00111101)
va4  a4   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b01111100)
va5  a5   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11010010)
va6  a6   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11111011)
va7  a7   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11101010)

vb0  b0   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11001000)
vb1  b1   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11000100)
vb2  b2   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11010101)
vb3  b3   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b10010000)
vb4  b4   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b00110001)
vb5  b5   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b10111000)
vb6  b6   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b01111110)
vb7  b7   gnd   pat(1.8 0  0.1n   0.1n  0.1n  19.9n b11010101)

*vb0  b0    gnd   pulse(1.8 0  0.1n   0.1n  0.1n  19.9n 40n)
*Vin in 0 PAT (5 0 0 1n 1n 10n b10110110101001) 



*transient analysis:Time step is 0.1n ,stop time is 80n
.tran 0.05n 200n *sweep(k 0.05p 1p 0.05p) 
*(sweep k 0.5u 2u 0.5u)

*delay analysis val=half of vdd
.meas tran delay_1 trig v(a4)   val=0.9 rise=1
+                  targ v(s6)   val=0.9 fall=1

.meas tran delay_2 trig v(a3)   val=0.9 rise=1
+                  targ v(s6)   val=0.9 rise=2

.meas tran delay_3 trig v(a5)   val=0.9 rise=1
+                  targ v(s4)   val=0.9 rise=2

.meas tran delay_4 trig v(a7)   val=0.9 rise=1
+                  targ v(s6)   val=0.9 fall=2

.meas tran delay_5 trig v(a7)   val=0.9 fall=2
+                  targ v(s5)   val=0.9 rise=4

.meas tran delay_6 trig v(a7)   val=0.9 rise=2
+                  targ v(s7)   val=0.9 fall=2

.meas tran delay_7 trig v(a3)   val=0.9 rise=2
+                  targ v(s7)   val=0.9 rise=2
*average_power analysis
.meas tran pw avg power

*power-Delay-Product(pdp) analysis
*.meas tran pdp=param('pw*delayN1')
*.probe digital s0 s1 s2 s3 s4 s5 s6 s7 s8 radix=hex
*.probe v(s*) 
.LPRINT (0.7,1.1) v(a*) v(b*) v(s*) 
*.PARAM VTH = 0.9
*.DOUT s0 VTH (0.0n 0 1.0n 1 2.0n X 5.0n 0)
*.DOUT s1 VTH (0.0n 0 1.0n 1 2.0n X 5.0n 0)
.end

