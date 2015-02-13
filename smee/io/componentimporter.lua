local FolderInspector = require "smee.io.folderinspector"

local ComponentImporter = {}

function ComponentImporter.loadComponentClasses(targetTable, folder)
    local componentFileList = FolderInspector.inspectList(FolderInspector.InspectTypeEnum.FULL_PATH, folder)
    dbgprint("Loading Components...")
    for i = 1, #componentFileList do
        local componentClass = loadfile(componentFileList[i])()
        targetTable[componentClass.name] = componentClass
        dbgprint(componentClass.name)
    end
end

return ComponentImporter