--- Core/FileLoaders/ZipFileLoader.h.orig	2025-05-31 21:01:42 UTC
+++ Core/FileLoaders/ZipFileLoader.h
@@ -2,7 +2,11 @@
 
 #include <mutex>
 
-#include <ext/libzip/zip.h>
+#ifdef SHARED_LIBZIP
+#include <zip.h>
+#else
+#include "ext/libzip/zip.h"
+#endif
 
 #include "Common/CommonTypes.h"
 #include "Common/Log.h"
