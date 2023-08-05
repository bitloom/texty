io.stdout:setvbuf('no')

function love.load()
 load()
end

function love.update(dt)
 game(dt)
end

function love.draw()
 draw()
end


function setWindowSize(w,h)
 love.window.setMode(w*baseCellW*screenScale, h*baseCellH*screenScale)
end

function setFont(filename)
 love.graphics.setDefaultFilter("nearest", "nearest", 1)
 font = love.graphics.newFont(filename, baseCellH * screenScale)
 love.graphics.setFont(font)
end

function setMVisible(visible)
 love.mouse.setVisible(visible)
end

function isMDown(button)
 return love.mouse.isDown(button);
end

function getMPos()
 return love.mouse.getPosition();
end

function clear(c)
 rect(0,0,gw,gh,c)
end

function screenshot(w,h)
 canvas = love.graphics.newCanvas(w*baseCellW*screenScale, h*baseCellH*screenScale)
 love.graphics.setCanvas(canvas)
 drawCanvas(0,0)
 love.graphics.setCanvas()
 local dir = love.filesystem.getSourceBaseDirectory()
 local success = love.filesystem.mount(dir, "Texty")
 canvas:newImageData():encode("png","texty.png")
 love.system.openURL("file://"..love.filesystem.getSaveDirectory())
end

function colour(c)
 rgba = pal[c]
 local rb = tonumber(string.sub(rgba, 2, 3), 16) / 255
 local gb = tonumber(string.sub(rgba, 4, 5), 16) / 255
 local bb = tonumber(string.sub(rgba, 6, 7), 16) / 255
 love.graphics.setColor(rb,gb,bb)
end

function text(txt, x, y, c)
 colour(c)
 love.graphics.print(txt, x*baseCellW*screenScale, y*baseCellH*screenScale)
end

function rect(x, y, w, h, c)
 colour(c)
 love.graphics.rectangle("fill", x*baseCellW*screenScale, y*baseCellH*screenScale, w*baseCellW*screenScale, h*baseCellH*screenScale)
end

function char(chr, x, y, c)
 colour(c)
 outchr = chr+31
 if (outchr<0) then outchr=0 end
 if (outchr>127) then outchr=127 end
 love.graphics.print(string.char(outchr), x*baseCellW*screenScale + (web and 1 or 0), y*baseCellH*screenScale)
end



pal={
 "#000000",
 "#1D2B53",
 "#7E2553",
 "#008751",
 "#AB5236",
 "#5F574F",
 "#C2C3C7",
 "#FFF1E8",
 "#FF004D",
 "#FFA300",
 "#FFEC27",
 "#00E436",
 "#29ADFF",
 "#83769C",
 "#FF77A8",
 "#FFCCAA"
}

web = false

screenScale=4
baseCellW=5
baseCellH=10

gw=40
gh=20

t=0

wx=2
wy=2
ww=0
wh=0
wc=6
wbc=1
wt="texty"

chx=32
chy=3
cnw=20
cnh=7

wg=false
mp=false

mx=0
my=0
cx=0
cy=0
cc=8

pb={1,2,3,4,5,6,7,8}
pf={9,10,11,12,13,14,15,16}

ch=0
b=pb[1]
f=pf[1]

cn={}
cnf={}
cnb={}


function load()
 setWindowSize(gw,gh)
 setMVisible(false)
 setFont("jgs5.ttf")
end

function game(dt)
 t=t+dt
 mp=isMDown(1)
 mx,my=getMPos()  
 cx=round(mx/(baseCellW*screenScale))
 cy=round(my/(baseCellH*screenScale))
 
 ww=cnw
 
 if (chx>ww) then ww=chx end
 if (#pb>ww) then ww=#pb end
 if (#pf>ww) then ww=#pf end
 
 wh=cnh+chy+1    
  
 if (#pb>1 and #pf>1) then wh=wh+1 end
 
 if (mp==true) then
  if (wg==false and cx==wx and cy==wy-1) then
   wg=true
  elseif (cx>=wx and cx<wx+chx 
    and cy>=wy+wh-chy and cy<wy+wh) then
   ch=(cx-wx)+(cy-(wy+wh-chy))*chx+1
  elseif (cx>=wx and cx<wx+cnw 
    and cy>=wy and cy<wy+cnh) then
   cn[(cx-wx)+(cy-wy)*cnw+1]=ch
   cnf[(cx-wx)+(cy-wy)*cnw+1]=f   
   cnb[(cx-wx)+(cy-wy)*cnw+1]=b                
  elseif (#pb>1 and cx>=wx and cx<wx+#pb 
    and cy==wy+cnh) then
   b=pb[cx-wx+1]              
  elseif (#pf>1 and cx>=wx and cx<wx+#pf 
    and ((#pb<=1 and cy==wy+cnh) or (#pb>0 and cy==wy+cnh+1))) then
   f=pf[cx-wx+1]                
  elseif (cx==wx+ww-1 and cy==wy-1) then
   screenshot(cnw,cnh)
  end                                          
 end
 
 if (wg==true) then
  if (mp==false) then
   wg=false
  end
  wx=cx
  wy=cy+1
 end
end

function draw()
 clear(2)

 drawWindow(wx,wy,ww,wh,wt,wc,wbc)

 drawCanvas(wx,wy)

 drawKeys(wx,(wy+wh-chy))
 
 if (wg==false) then
  drawCursor()
 end
end

function drawWindow(x,y,w,h,tt,c,bc)
 rect(x,(y-1),w,(h+1),c)
 rect(x,y,w,h,bc)
 
 rect(x,(y+cnh),w,1,c)

 rect(x+cnw,y,w-cnw,cnh,c)
  
 po=0
 if (#pb>1) then
  for pbx=1,#pb do
   if(pb[pbx]~=b or (t%0.5)<0.25) then 
    rect((x+pbx-1),(y+cnh),1,1,pb[pbx])
   end
  end
  po=1
 end
 if (#pf>1) then
  if (po==1) then
   rect(x,y+cnh+1,w,1,c)
  end
     
  for pfx=1,#pf do
   if(pf[pfx]~=f or (t%0.5)<0.25) then   
    rect((x+pfx-1),(y+cnh+po),1,1,pf[pfx]) 
   end
  end
 end
 
 rect(x,(y-1),w,1,c)
 
 if (wg == false or (t%0.5)<0.25) then 
  char(11,x,(y-1),bc)
 end
 
 char(84,(x+w-1),(y-1),bc)
 
 rect(x,(y+h-chy),chx,chy,b)
end

function drawKeys(x,y)
 for kx=1,chx do
  for ky=0,chy-1 do 
   if (ch ~= kx+ky*chx or (t%0.5)<0.25) then
    char(kx+ky*chx,(x+kx-1),(y+ky),f) 
   end
  end
 end
end

function drawCanvas(x,y)
 for cnx=1,cnw do
  for cny=0,cnh-1 do 
   if(cn[cnx+cny*cnw] ~= nil) then
    chf=1
    chb=1
    
    if(cnf[cnx+cny*cnw] ~= nil) then
     chf=cnf[cnx+cny*cnw]
    end
    
    if(cnb[cnx+cny*cnw] ~= nil) then
     chb=cnb[cnx+cny*cnw]
    end
    
    rect((x+cnx-1),(y+cny),1,1,chb)
    char(cn[cnx+cny*cnw],(x+cnx-1),(y+cny),chf)
   end
  end
 end
end

function drawCursor()               
 if cx>=wx and cx<wx+cnw 
   and cy>=wy and cy<wy+cnh then
  rect(cx,cy,1,1,b)
  char(ch,cx,cy,f)  
 end

 if ((t%0.5)<0.25) then
  rect(cx,cy,1,1,wbc)
  char(64,cx,cy,cc)
 end       
end

function round(num)
  return num + (2^52 + 2^51) - (2^52 + 2^51)
end  