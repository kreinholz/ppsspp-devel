--- Core/Util/PortManager.h.orig	2025-05-31 21:56:31 UTC
+++ Core/Util/PortManager.h
@@ -22,9 +22,9 @@
 #pragma once
 
 #ifdef USE_SYSTEM_MINIUPNPC
-#include <miniupnpc/include/miniwget.h>
-#include <miniupnpc/include/miniupnpc.h>
-#include <miniupnpc/include/upnpcommands.h>
+#include <miniupnpc/miniwget.h>
+#include <miniupnpc/miniupnpc.h>
+#include <miniupnpc/upnpcommands.h>
 #else
 #ifndef MINIUPNP_STATICLIB
 #define MINIUPNP_STATICLIB
