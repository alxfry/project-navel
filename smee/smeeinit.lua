print("*** SpiceMinionEngineExtension has been starting ***")
require "smee.dbginit"
print(" ** debug functions loaded **")
SMEE = {}
print(" ** global SMEE table allocated **")
SMEE.Flux = require "smee.libs.flux"
print(" ** flux tweening lib loaded **")
print("*** SpiceMinionEngineExtension started. You can now use SMEE components. ***")