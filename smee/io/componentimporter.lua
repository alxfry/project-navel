local FolderInspector = require "smee.io.folderinspector"

local ComponentImporter = {}

function ComponentImporter.loadComponentClasses(targetTable, folder)
    local componentFileList = FolderInspector.inspectList(FolderInspector.InspectTypeEnum.FULL_PATH, folder)
    dbgprint("Loading Components...")
    for i = 1, #componentFileList do
        local loadfunc, err = loadfile(componentFileList[i])
        assert(not err, err)
        local componentClass = loadfunc()
        targetTable[componentClass.name] = componentClass
        dbgprint(componentClass.name)
    end
end

return ComponentImporter