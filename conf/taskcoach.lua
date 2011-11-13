TC_SUBJECT="subject"
TC_ID="id"
TC_TASKLIST="categorizables"
TC_COLOR="color"
TC_PRIOR="priority"

tasks = {}
tc_db_tasks = {}

function hook_taskcoach_reload()
   local nrtasks=1
   local file=home.."/.taches.tsk"
   f = io.open(file,"r")
   if f then
       s = f:read("*all")
       f:close()
   end
  
   tasks = {}
   tc_db_tasks = {}
   
   i = string.find(s,"<category")
   tc_tasks = string.sub(s,1,i-1) .. "</tasks>"
   tc_cat = string.sub(s,1,string.find(s,"<tasks>")-1) .. "<tasks>" .. string.sub(s,i,string.find(s,"<syncml")-1) .. "</tasks>"
   tc_db_tasks = etree.fromstring(tc_tasks)

   for i=1,#tc_db_tasks do
       if not tc_db_tasks[i].attr["completiondate"] then
           tasks[nrtasks] = {}
           tasks[nrtasks].subject = tc_db_tasks[i].attr[TC_SUBJECT]
           tasks[nrtasks].id = tc_db_tasks[i].attr[TC_ID]
           if tc_db_tasks[i].attr[TC_PRIOR] then
               tasks[nrtasks].priority = tonumber(tc_db_tasks[i].attr[TC_PRIOR])
           else
               tasks[nrtasks].priority = 0
           end
           tasks[nrtasks].category = {}
           nrtasks = nrtasks + 1
       end
   end

   tc_db_cat = etree.fromstring(tc_cat)
   taskcoach_walk(tc_db_cat,"","")
   table.sort(tasks,function(a,b) return a.priority > b.priority end)
naughty.notify({
           text = tasks[1].subject,
           timeout = 10, hover_timeout = 1,
           width = 500, position = "top_right", screen = mouse.screen
         })
end

function hook_taskcoach_print()
   tb_todo.text = "Tâches "..#tasks
end

function taskcoach_walk(where,cat,color)
   if where then
       local i
       for i=1,#where do
           local tmp = cat
           local tmp_color
           if where[i] then if where[i].attr then
               if where[i].attr[TC_COLOR] then
                   tmp_color = where[i].attr[TC_COLOR]
               else
                   tmp_color = color
               end
               if where[i].attr[TC_SUBJECT] then
                   if tmp ~= "" then
                       tmp = tmp .. "/"
                   else
                       tmp = "("
                   end
                   tmp = tmp ..  where[i].attr[TC_SUBJECT]
                   for j=1,#tasks do
                       if where[i].attr[TC_TASKLIST] then
                           k = string.find(where[i].attr[TC_TASKLIST],tasks[j].id)
                           if k then
                               tasks[j].category[#tasks[j].category+1]=tmp .. ")"
                               local color_dec = {}
                               local TMP_COLOR = tmp_color
                               for l=1,3 do
                                   color_b, color_e = string.find(TMP_COLOR,"%d+,")
                                   color_dec[l] = string.sub(TMP_COLOR,color_b,color_e-1)
                                   TMP_COLOR = string.sub(TMP_COLOR,color_e+1,-1)
                               end
                               tasks[j].color = string.format("#%.2X%.2X%.2X",color_dec[1],color_dec[2],color_dec[3])
                           end
                       end
                   end
               end
           end end
           taskcoach_walk(where[i],tmp,tmp_color)
       end
   end
end

awful.hooks.timer.register(21, hook_taskcoach_reload)
awful.hooks.timer.register(10, hook_taskcoach_print)
tb_todo = widget({ type = "textbox" })
tb_todo.text ="foobar"
tb_todo:buttons({
   button({},1,function() hook_print_tasks() end)
})

notify_tasks = nil 
function hook_print_tasks ()
   if not notify_tasks then 
       local msg = ""
       for i=1,#tasks do
           tmp = tasks[i].subject
           for j=1,#tasks[i].category do
               if tasks[i].priority then msg = msg .. tasks[i].priority .. " " end 
               msg = msg .. ""
               msg = msg .. tasks[i].subject .. " " ..  tasks[i].category[j] .. "\n"
           end 
       end 
       notify_tasks = naughty.notify({ 
           text = msg, 
           title = "Tâches",
--           timeout = 0,  
--           position = pos,
--           width = 600,
--           bg = "#000000cc",
--           border_color = "#aa0000",
--           border_width = 7,
           run = function() naughty.destroy(notify_tasks) notify_tasks = nil end
       })  
   else
       naughty.destroy(notify_tasks)
       notify_tasks = nil 
   end 
end


