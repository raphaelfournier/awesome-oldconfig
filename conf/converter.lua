--module("conf.converter.converter")
function converter(expression)
      index = 1
      words={}
      sep = 0
      localequiv="font "
      localand="et "
      for word in expression:gmatch("%w+") 
      do 
        words[index]=word
        if word == "en" then sep = index end
        index= index+1
      end
      if index ~=1 and #words == sep + 1 then 
        if words[sep+1] == "C" then
          celsius = awful.util.pread("echo \"scale=2;(" .. words[1] .."-32)*5/9\" | bc -l")
          kelvin = celsius + 273.15
          answer = words[1].."°F "..localequiv..celsius:sub(1,#celsius-1).."°C\nand to "..kelvin.."°K"
        elseif words[sep+1] == "F" then
          farenheit = awful.util.pread("echo \"scale=2;(" .. words[1] .."*9/5)+32\" | bc -l")
          kelvin = words[1] + 273.15
          answer = words[1].."°C equals to "..farenheit:sub(1,#celsius-1).."°F\n"..localand..kelvin.."°K"
        elseif words[sep+1] == "km" then
          answer = words[1].." miles ".. localequiv..words[1]*1.609 .." km"
        elseif words[sep+1] == "miles" then
          answer = words[1].." km equals to ".. words[1]/1.609 .." miles"
        elseif words[sep+1] == "litres" then
          answer = words[1].." gallons ".. localequiv..words[1]*3.785 .." litres"
        elseif words[sep+1] == "gallons" then
          answer = words[1].." litres equals to ".. words[1]/3.785 .." gallons"
        elseif words[sep+1] == "kg" then
          answer = words[1].." lb ".. localequiv..words[1]*0.45359237 .." kg"
        elseif words[sep+1] == "lb" then
          answer = words[1].." kg equals to ".. words[1]/0.45359237 .." lb"
        elseif words[sep+1] == "sqm" then
          answer = words[1].." sq ft ".. localequiv..words[1]*0.09290304 .." mètres carrés"
        elseif words[sep+1] == "sqft" then
          answer = words[1].." mètres carrés equals to ".. words[1]/0.09290304 .." sq ft"
        elseif words[sep+1] == "ml" then
          answer = words[1].." ounce ".. localequiv..words[1]*28.4130625 .." ml"
        elseif words[sep+1] == "ounce" then
          answer = words[1].." ml ".. localequiv..words[1]/28.4130625 .." ounces"
        elseif words[sep+1] == "eur" then
          answer = words[1].." usd ".. localequiv..words[1]/1.35870 .." euros"
        elseif words[sep+1] == "usd" then
          answer = words[1].." eur ".. localequiv..words[1]*1.35870 .." US dollars"
        elseif words[sep+1] == "cm" then
          cm = words[1]*30.48+words[3]*2.54
          answer = words[1].." ft ".. words[3].." inches ".. localequiv..cm .." centimètres"
        elseif words[sep+1] == "imperial" then
          ft = (words[1]-(words[1]%30.48))/30.48
          inch = (words[1]%30.48)/2.54
          answer = words[1] .. " cm equals to ".. ft .. " feet and "..inch.." inches"
        end
      else
          answer = "problem with your input"
      end
          naughty.notify({ text = answer, width = 400})
end
