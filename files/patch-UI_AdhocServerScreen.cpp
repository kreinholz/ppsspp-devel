--- UI/AdhocServerScreen.cpp.orig	2026-04-09 14:20:24 UTC
+++ UI/AdhocServerScreen.cpp
@@ -3,7 +3,7 @@
 #include "ppsspp_config.h"
 
 #undef new
-#include "ext/rapidjson/include/rapidjson/document.h"
+#include <rapidjson/document.h>
 #include "Common/DbgNew.h"
 
 #include "AdhocServerScreen.h"
