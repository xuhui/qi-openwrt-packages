--[[ $Id: x31.lua 9533 2009-02-16 22:18:37Z smekal $

  Copyright (C) 2008 Werner Smekal

  set/get tester

  This file is part of PLplot.
  
  PLplot is free software you can redistribute it and/or modify
  it under the terms of the GNU General Library Public License as published
  by the Free Software Foundation either version 2 of the License, or
  (at your option) any later version.
  
  PLplot is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Library General Public License for more details.
  
  You should have received a copy of the GNU Library General Public License
  along with PLplot if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
--]]


-- initialise Lua bindings for PLplot examples.
dofile("plplot_examples.lua")

r1 = { 0, 255 }
g1 = { 255, 0 }
b1 = { 0, 0 }
a1 = { 1, 1 }

-- Parse and process command line arguments 
status = 0
pl.parseopts(arg, pl.PL_PARSE_FULL)

-- Test setting / getting familying parameters before plinit 
-- Save values set by plparseopts to be restored later. 
fam0, num0, bmax0 = pl.gfam()
fam1 = 0
num1 = 10
bmax1 = 1000
pl.sfam(fam1, num1, bmax1)

-- Retrieve the same values? 
fam2, num2, bmax2 = pl.gfam()
print(string.format("family parameters: fam, num, bmax = %d %d %d", fam2, num2, bmax2))
if fam2~=fam1 or num2~=num1 or bmax2~=bmax1 then
  io.stderr:write("plgfam test failed\n")
  status = 1
end
-- Restore values set initially by plparseopts. 
pl.sfam(fam0, num0, bmax0)

-- Test setting / getting page parameters before plinit 
-- Save values set by plparseopts to be restored later. 
xp0, yp0, xleng0, yleng0, xoff0, yoff0 = pl.gpage()
xp1 = 200.
yp1 = 200.
xleng1 = 400
yleng1 = 200
xoff1 = 10
yoff1 = 20
pl.spage(xp1, yp1, xleng1, yleng1, xoff1, yoff1)

-- Retrieve the same values? 
xp2, yp2, xleng2, yleng2, xoff2, yoff2 = pl.gpage()
print(string.format("page parameters: xp, yp, xleng, yleng, xoff, yoff = %f %f %d %d %d %d", xp2, yp2, xleng2, yleng2, xoff2, yoff2))
if xp2~=xp1 or yp2~=yp1 or xleng2~=xleng1 or yleng2~=yleng1 or xoff2~=xoff1 or yoff2~=yoff1 then
  io.stderr:write("plgpage test failed\n")
  status = 1
end
-- Restore values set initially by plparseopts. 
pl.spage(xp0, yp0, xleng0, yleng0, xoff0, yoff0)

-- Test setting / getting compression parameter across plinit. 
compression1 = 95
pl.scompression(compression1)

-- Initialize plplot 
pl.init()

-- Test if device initialization screwed around with the preset
-- compression parameter. 
compression2 = pl.gcompression()
print("Output various PLplot parameters")
print("compression parameter = " .. compression2)
if compression2~=compression1 then
  io.stderr:write("plgcompression test failed\n")
  status = 1
end


-- Exercise plscolor, plscol0, plscmap1, and plscmap1a to make sure
--they work without any obvious error messages. 
pl.scolor(1)
pl.scol0(1, 255, 0, 0)
pl.scmap1(r1, g1, b1)
pl.scmap1a(r1, g1, b1, a1)

level2 = pl.glevel()
print("level parameter = " .. level2)
if level2~=1 then
  io.stderr:write("plglevel test failed.\n")
  status = 1
end

pl.adv(0)
pl.vpor(0.01, 0.99, 0.02, 0.49)
xmin, xmax, ymin, ymax = pl.gvpd()
print(string.format("plvpor: xmin, xmax, ymin, ymax = %f %f %f %f", xmin, xmax, ymin, ymax))
if xmin~=0.01 or xmax~=0.99 or ymin~=0.02 or ymax~=0.49 then
  io.stderr:write("plgvpd test failed\n")
  status = 1
end
xmid = 0.5*(xmin+xmax)
ymid = 0.5*(ymin+ymax)

pl.wind(0.2, 0.3, 0.4, 0.5)
xmin, xmax, ymin, ymax = pl.gvpw()
print(string.format("plwind: xmin, xmax, ymin, ymax = %f %f %f %f", xmin, xmax, ymin, ymax))
if xmin~=0.2 or xmax~=0.3 or ymin~=0.4 or ymax~=0.5 then
  io.stderr:write("plgvpw test failed\n")
  status = 1
end

-- Get world coordinates for middle of viewport 
wx, wy, win = pl.calc_world(xmid,ymid)
print(string.format("world parameters: wx, wy, win = %f %f %d", wx, wy, win))
if math.abs(wx-0.5*(xmin+xmax))>1.0e-5 or math.abs(wy-0.5*(ymin+ymax))>1.0e-5 then
  io.stderr:write("plcalc_world test failed\n")
  status = 1    
end

-- Retrieve and print the name of the output file (if any).
-- This goes to stderr not stdout since it will vary between tests and 
-- we want stdout to be identical for compare test. 
fnam = pl.gfnam()
if fnam=="" then
  print("No output file name is set")
else 
  print("Output file name read")
end
io.stderr:write(string.format("Output file name is %s\n",fnam))

-- Set and get the number of digits used to display axis labels 
-- Note digits is currently ignored in pls[xyz]ax and 
-- therefore it does not make sense to test the returned 
-- value 
pl.sxax(3,0)
digmax, digits = pl.gxax()
print(string.format("x axis parameters: digmax, digits = %d %d", digmax, digits))
if digmax~=3 then
  io.stderr:write("plgxax test failed\n")
  status = 1
end

pl.syax(4,0)
digmax, digits = pl.gyax()
print(string.format("y axis parameters: digmax, digits = %d %d", digmax, digits))
if digmax~=4 then
  io.stderr:write("plgyax test failed\n")
  status = 1
end

pl.szax(5,0)
digmax,digits = pl.gzax()
print(string.format("z axis parameters: digmax, digits = %d %d", digmax, digits))
if digmax~=5 then
  io.stderr:write("plgzax test failed\n")
  status = 1
end

pl.sdidev(0.05, pl.PL_NOTSET, 0.1, 0.2)
mar, aspect, jx, jy = pl.gdidev()
print(string.format("device-space window parameters: mar, aspect, jx, jy = %f %f %f %f" , mar, aspect, jx, jy))
if mar~=0.05 or jx~=0.1 or jy~=0.2 then
  io.stderr:write("plgdidev test failed\n")
  status = 1
end

pl.sdiori(1.0)
ori = pl.gdiori()
print(string.format("ori parameter = %f", ori))
if ori~=1.0 then
  io.stderr:write("plgdiori test failed\n")
  status = 1
end

pl.sdiplt(0.1, 0.2, 0.9, 0.8)
xmin, ymin, xmax, ymax = pl.gdiplt()
print(string.format("plot-space window parameters: xmin, ymin, xmax, ymax = %f %f %f %f", xmin, ymin, xmax, ymax))
if xmin~=0.1 or xmax~=0.9 or ymin~=0.2 or ymax~=0.8 then
  io.stderr:write("plgdiplt test failed\n")
  status = 1
end

pl.sdiplz(0.1, 0.1, 0.9, 0.9)
zxmin, zymin, zxmax, zymax = pl.gdiplt()
print(string.format("zoomed plot-space window parameters: xmin, ymin, xmax, ymax = %f %f %f %f", zxmin, zymin, zxmax, zymax))
if math.abs(zxmin -(xmin + (xmax-xmin)*0.1)) > 1.0e-5 or 
   math.abs(zxmax -(xmin+(xmax-xmin)*0.9)) > 1.0e-5 or 
   math.abs(zymin -(ymin+(ymax-ymin)*0.1)) > 1.0e-5 or 
   math.abs(zymax -(ymin+(ymax-ymin)*0.9)) > 1.0e-5 then
  io.stderr:write("plsdiplz test failed\n")
  status = 1
end

pl.scolbg(10, 20, 30)
r, g, b = pl.gcolbg()
print(string.format("background colour parameters: r, g, b = %d %d %d", r, g, b))
if r~=10 or g~=20 or b~=30 then 
  io.stderr:write("plgcolbg test failed\n")
  status = 1
end

pl.scolbga(20, 30, 40, 0.5)
r, g, b, a = pl.gcolbga()
print(string.format("background/transparency colour parameters: r, g, b, a = %d %d %d %f", r, g, b, a))
if r~=20 or g~=30 or b~=40 or a~=0.5 then
  io.stderr:write("plgcolbga test failed\n")
  status = 1
end

pl.plend()
