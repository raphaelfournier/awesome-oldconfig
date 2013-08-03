local awful= require("awful")
local naughty   = require("naughty")

local unitconverter = {}

function unitconverter.prompt()
  awful.prompt.run({ 
    fg_cursor = "black",bg_cursor="blue", prompt = " Convertir " }, 
    mypromptbox[mouse.screen].widget,
    function(expression)
      index = 1
      words={}
      sep = 0
      localequiv="font "
      localand="et "
      localto="en"
      help = "HELP\n"
      for word in expression:gmatch("%w+") 
      do 
        words[index]=word
        if word == localto then sep = index end
        index= index+1
      end
      if index ~=1 and #words == sep + 1 then 
        height = 100
        destunit = words[sep+1]
        if destunit == "C" then
          answer = words[1].." F ".. localequiv..(words[1]-32)*5/9 .." C"
        elseif destunit == "F" then
          answer = words[1].." C ".. localequiv..(words[1]*9/5)-32 .." F"
        elseif destunit == "km" then
          answer = words[1].." miles ".. localequiv..words[1]*1.609 .." km"
        elseif destunit == "miles" then
          answer = words[1].." km ".. localequiv.. words[1]/1.609 .." miles"
        elseif destunit == "litres" then
          answer = words[1].." gallons ".. localequiv..words[1]*3.785 .." litres"
        elseif destunit == "gallons" then
          answer = words[1].." litres ".. localequiv.. words[1]/3.785 .." gallons"
        elseif destunit == "kg" then
          answer = words[1].." lb ".. localequiv..words[1]*0.45359237 .." kg"
        elseif destunit == "lb" then
          answer = words[1].." kg ".. localequiv.. words[1]/0.45359237 .." lb"
        elseif destunit == "m2" then
          answer = words[1].." sq ft ".. localequiv..words[1]*0.09290304 .." mètres carrés"
        elseif destunit == "sqft" then
          answer = words[1].." mètres carrés ".. localequiv.. words[1]/0.09290304 .." sq ft"
        elseif destunit == "ml" then
          answer = words[1].." ounce ".. localequiv..words[1]*28.4130625 .." ml"
        elseif destunit == "ounce" then
          answer = words[1].." ml ".. localequiv..words[1]/28.4130625 .." ounces"
        elseif destunit == "eur" then
          answer = words[1].." usd ".. localequiv..words[1]/1.35870 .." euros"
        elseif destunit == "usd" then
          answer = words[1].." eur ".. localequiv..words[1]*1.35870 .." US dollars"
        elseif destunit == "cm" then
          cm = words[1]*30.48+words[3]*2.54
          answer = words[1].." ft ".. words[3].." inches ".. localequiv..cm .." centimètres"
        elseif destunit == "imperial" then
          ft = (words[1]-(words[1]%30.48))/30.48
          inch = (words[1]%30.48)/2.54
          answer = words[1] .. " cm "..localequiv.. ft .. " feet and "..inch.." inches"
    elseif #words == 1 and words[1] == "help" then
      help = help .. " xx C "..localto.." F".."\n"
      help = help .. " xx F "..localto.." C".."\n"
      help = help .. " xx miles "..localto.." km".."\n"
      help = help .. " xx km "..localto.." miles".."\n"
      help = help .. " xx litres "..localto.." gallons".."\n"
      help = help .. " xx gallons "..localto.." litres".."\n"
      help = help .. " xx kg "..localto.." lb".."\n"
      help = help .. " xx lb "..localto.." kg".."\n"
      help = help .. " xx m2 "..localto.." sq ft".."\n"
      help = help .. " xx sq ft "..localto.." m2".."\n"
      help = help .. " xx ml "..localto.." ounce".."\n"
      help = help .. " xx ounce "..localto.." ml".."\n"
      help = help .. " xx eur "..localto.." usd".."\n"
      help = help .. " xx usd "..localto.." eur".."\n"
      help = help .. " xx cm "..localto.." imperial".."\n"
      help = help .. " xx ft yy in "..localto.." cm".."\n"
      answer = help
      height = 600
      end
    else
          answer = "problem with your input. #words="..#words
      end
          naughty.notify({ text = answer, width = 400, height = height, screen=mouse.screen})
    end,
    nil, awful.util.getdir("cache") .. "/convert") 
end

return unitconverter
