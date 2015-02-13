local FolderInspector = require "smee.io.folderinspector"

local ComponentImporter = {}

function ComponentImporter.loadComponentClasses(targetTable, folder)
    local componentFileList = FolderInspector.inspectList(FolderInspector.InspectTypeEnum.FULL_PATH, folder)
    if componentFileList[1] then
        print(componentFileList[1])
    end
end

return ComponentImporter