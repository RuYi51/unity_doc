local lfs = lfs or require("lfs")

function lsdir(path, ext, ret)
    ret = ret or {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path.."/"..file
            local a = lfs.attributes(f)
            if a and a.mode == "directory" then
                lsdir(f, ext, ret)
            else
                if ext then
                    if string.match(f, ext) then
                        table.insert(ret, f)
                    end
                else
                    table.insert(ret, f)
                end
            end
        end
    end
    return ret
end

function readFile(file)
    local fd = io.open(file, "rb")
    if fd then
        local text = fd:read("*a")
        fd:close()
        return text
    end
end

function writeFile(file, content)
    local fd = io.open(file, "w+b")
    fd:write(content)
	fd:close()
end


local docPath = "W:/doc/unity2019/"
local folders = {
	"ScriptReference",
	"Manual",
}
local pattern = " src=\"https://cdn.cookielaw.org/scripttemplates/otSDKStub.js\" charset=\"UTF%-8\" data%-domain%-script=\"6e91be4c%-3145%-4ea2%-aa64%-89d716064836\""

for _,folder in pairs(folders) do
	local files = lsdir(docPath .. folder)
	for _,file in pairs(files) do
		local content = readFile(file)
		local sidx,eidx = string.find(content, pattern)
		if sidx and eidx then
			content = string.sub(content, 1, sidx - 1) .. string.sub(content, eidx + 1)
			writeFile(file, content)
		end
	end
end
