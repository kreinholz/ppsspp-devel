--- Core/FileLoaders/ZipFileLoader.cpp.orig	2025-05-31 19:40:58 UTC
+++ Core/FileLoaders/ZipFileLoader.cpp
@@ -1,4 +1,8 @@
-#include <ext/libzip/zip.h>
+#ifdef SHARED_LIBZIP
+#include <zip.h>
+#else
+#include "ext/libzip/zip.h"
+#endif
 
 #include "Core/FileLoaders/LocalFileLoader.h"
 #include "Core/FileLoaders/ZipFileLoader.h"
