local body = env.dyn.html.Body.new()

body:addHeader(2, "Nameless Server Network")
body:addP("Nameless Server Network is a non commercial organisation, mainly hosting game servers.")
body:addP("Our servers belong to different Communities. A list of all Communities hosting their servers in our network can be found below.")
body:addP("Since we are working non commercial at the moment we are not in imprint duty. But if you want to cantact us directly you can do that via email at " .. body:addLink("mailto:contact@namelessserver.net", "contact@namelessserver.net") .. ".") --WIP

body:addHeader(2, "Communities")
body:addHeader(3, "ProjectOC")
body:addP("ProjectOC is a minecraft community mainly focused on programming / technical minecraft modpacks.")
body:addP("Links:")
body:addLink("https://oc.cil.li/topic/1861-projectoc-oc-based-suvival-server-with-ftp-file-access/", "OpenComputers forum")
body:addP("")
body:addLink("https://github.com/Project-Open-Computers/POC3", "GitHub")

body:addHeader(3, "OpenPlayVerse")
body:addP("...")


return body:generateCode()