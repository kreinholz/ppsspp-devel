--- Core/Loaders.h.orig	2025-05-31 19:39:48 UTC
+++ Core/Loaders.h
@@ -20,7 +20,11 @@
 #include <string>
 #include <memory>
 
+#ifdef SHARED_LIBZIP
+#include <zip.h>
+#else
 #include "ext/libzip/zip.h"
+#endif
 #include "Common/CommonTypes.h"
 #include "Common/File/Path.h"
 
