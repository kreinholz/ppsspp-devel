PORTNAME=	ppsspp
PORTVERSION=	20250530.b53e44f
CATEGORIES=	emulators
# XXX Get from Debian once #697821 lands
MASTER_SITES=	https://bazaar.launchpad.net/~sergio-br2/${PORTNAME}/debian-sdl/download/5/${PORTNAME}.1-20140802045408-dd26dik367ztj5xg-8/:manpage \
		https://github.com/hrydgard/ppsspp-ffmpeg/commit/9c4f84d9d9ad147f4a44cff582829647a0c65420.patch/:ffmpegpatch
DISTFILES=	${PORTNAME}.1:manpage \
		9c4f84d9d9ad147f4a44cff582829647a0c65420.patch:ffmpegpatch
EXTRACT_ONLY=	${DISTFILES:N*\:manpage:N*\:ffmpegpatch:C/:.*//}

CONFLICTS_INSTALL=	ppsspp

MAINTAINER=	kreinholz@gmail.com
COMMENT=	PSP emulator in C++ with dynarec JIT for x86, ARM, MIPS
WWW=		https://www.ppsspp.org/

LICENSE=	GPLv2+

# Bi-endian architectures default to big for some reason
NOT_FOR_ARCHS=	mips mips64 powerpc powerpc64 powerpcspe
NOT_FOR_ARCHS_REASON=	only little-endian is supported, see \
		https://github.com/hrydgard/ppsspp/issues/8823

BUILD_DEPENDS=	gmake:devel/gmake

LIB_DEPENDS=	#libzip.so:archivers/libzip \
		libsnappy.so:archivers/snappy \
		libzstd.so:archivers/zstd \
		libopenxr_loader.so:graphics/openxr
RUN_DEPENDS=	xdg-open:devel/xdg-utils

USES=		cmake compiler:c++11-lib gl localbase:ldflags pkgconfig \
		shebangfix desktop-file-utils
USE_GITHUB=	yes
GH_ACCOUNT=	hrydgard
GH_PROJECT=	ppsspp
GH_TAGNAME=	b53e44f
GH_TUPLE?=	hrydgard:glslang:8.13.3743-948-g50e0708:glslang/ext/glslang \
		google:cpu_features:v0.8.0-27-gfd4ffc1:cpu_features/ext/cpu_features \
		FFmpeg:FFmpeg:n3.0.2-gc66f4d1:ffmpeg/ffmpeg \
		rtissera:libchdr:26d27ca:libchdr/ext/libchdr \
		unknownbrackets:ppsspp-debugger:d358a87:debugger/assets/debugger \
		KhronosGroup:SPIRV-Cross:sdk-1.3.239.0:SPIRV/ext/SPIRV-Cross \
		Kingcom:armips:v0.11.0-195-ga8d71f0:armips/ext/armips \
		Kingcom:filesystem:v1.3.2-12-g3f1c185:filesystem/ext/armips/ext/filesystem \
		RetroAchievements:rcheevos:v11.6.0-g4697f97:rcheevos/ext/rcheevos \
		Tencent:rapidjson:v1.1.0-415-g73063f5:rapidjson/ext/rapidjson \
		miniupnp:miniupnp:miniupnpd_2_3_7-g27d13ca:miniupnp/ext/miniupnp \
		hrydgard:ppsspp-lua:7648485:lua/ext/lua
EXCLUDE=	zlib
USE_GL=		glew opengl
CMAKE_ON=	${LIBZIP SNAPPY ZSTD:L:S/^/USE_SYSTEM_/} USE_VULKAN_DISPLAY_KHR
CMAKE_OFF=	USE_DISCORD
LDFLAGS+=	-Wl,--as-needed # ICE/SM/X11/Xext, Qt5Network
CONFLICTS_INSTALL=	${PORTNAME}-*
DESKTOP_ENTRIES=	"PPSSPP" \
			"" \
			"${PORTNAME}" \
			"${PORTNAME} %f" \
			"Game;Emulator;" \
			""
EXTRACT_AFTER_ARGS=	${EXCLUDE:S,^,--exclude ,}
SUB_FILES=	pkg-message
PORTDATA=	assets

OPTIONS_DEFINE=		VULKAN
OPTIONS_DEFAULT=	VULKAN
OPTIONS_SINGLE=		GUI
OPTIONS_SINGLE_GUI=	LIBRETRO QT5 SDL
OPTIONS_EXCLUDE:=	${OPTIONS_EXCLUDE} ${OPTIONS_SINGLE_GUI}
OPTIONS_SLAVE?=		SDL

LIBRETRO_DESC=		libretro core for games/retroarch
VULKAN_DESC=		Vulkan renderer
LIBRETRO_LIB_DEPENDS=	libpng.so:graphics/png
LIBRETRO_CMAKE_BOOL=	LIBRETRO
LIBRETRO_PLIST_FILES=	lib/libretro/${PORTNAME}_libretro.so
LIBRETRO_VARS=		CONFLICTS_INSTALL= DESKTOP_ENTRIES= PLIST= PORTDATA= PKGMESSAGE= SUB_FILES=
QT5_LIB_DEPENDS=	libpng.so:graphics/png
QT5_USES=		desktop-file-utils qt:5 shared-mime-info sdl
QT5_USE=		QT=qmake:build,buildtools:build,linguisttools:build,core,gui,multimedia,opengl,widgets
QT5_USE+=		SDL=sdl2 # audio, joystick
QT5_CMAKE_BOOL=		USING_QT_UI
QT5_VARS=		EXENAME=PPSSPPQt
SDL_CATEGORIES=		wayland
SDL_LIB_DEPENDS=	libpng.so:graphics/png
SDL_USES=		shared-mime-info sdl
SDL_USE=		SDL=sdl2
SDL_VARS=		EXENAME=PPSSPPSDL
VULKAN_RUN_DEPENDS=	${LOCALBASE}/lib/libvulkan.so:graphics/vulkan-loader

FFMPEG_CONFIGURE_ARGS=	--disable-debug \
			--enable-static \
			--disable-shared \
			--enable-pic \
			--enable-zlib \
			--disable-everything \
			--enable-gpl \
			--cc="${CC}" \
			--cxx="${CXX}" \
			--disable-avdevice \
			--disable-filters \
			--disable-programs \
			--disable-network \
			--disable-avfilter \
			--disable-postproc \
			--disable-encoders \
			--disable-doc \
			--disable-ffplay \
			--disable-ffprobe \
			--disable-ffserver \
			--disable-ffmpeg \
			--enable-decoder=h264 \
			--enable-decoder=mpeg4 \
			--enable-decoder=h263 \
			--enable-decoder=h263p \
			--enable-decoder=mpeg2video \
			--enable-decoder=mjpeg \
			--enable-decoder=mjpegb \
			--enable-decoder=aac \
			--enable-decoder=aac_latm \
			--enable-decoder=atrac3 \
			--enable-decoder=atrac3p \
			--enable-decoder=mp3 \
			--enable-decoder=pcm_s16le \
			--enable-decoder=pcm_s8 \
			--enable-demuxer=h264 \
			--enable-demuxer=h263 \
			--enable-demuxer=m4v \
			--enable-demuxer=mpegps \
			--enable-demuxer=mpegvideo \
			--enable-demuxer=avi \
			--enable-demuxer=mp3 \
			--enable-demuxer=aac \
			--enable-demuxer=pmp \
			--enable-demuxer=oma \
			--enable-demuxer=pcm_s16le \
			--enable-demuxer=pcm_s8 \
			--enable-demuxer=wav \
			--enable-encoder=ffv1 \
			--enable-encoder=huffyuv \
			--enable-encoder=mpeg4 \
			--enable-encoder=pcm_s16le \
			--enable-muxer=avi \
			--enable-parser=h264 \
			--enable-parser=mpeg4video \
			--enable-parser=mpegvideo \
			--enable-parser=aac \
			--enable-parser=aac_latm \
			--enable-parser=mpegaudio \
			--enable-protocol=file \
			--disable-sdl \
			--disable-asm \
			--disable-iconv \
			--disable-vaapi \
			--disable-hwaccels \
			--enable-lto \
			--enable-optimizations \
			--enable-runtime-cpudetect
SHEBANG_FILES=	${WRKSRC}/ffmpeg/doc/texi2pod.pl

post-patch:
	# apply FreeBSD patches for ffmpeg
	for p in ${PATCHDIR}/ffmpeg/patch-*;do \
		${PATCH} -s -p0 -d ${WRKSRC}/ffmpeg < $${p}; \
	done
	# apply upstream ppsspp-ffmpeg patch to ffmpeg-3.0.2 sources
	${PATCH} -s -p1 -d ${WRKSRC}/ffmpeg < ${_DISTDIR}/9c4f84d9d9ad147f4a44cff582829647a0c65420.patch
	# apply FreeBSD substitutions in PPSSPP sources
	@${REINPLACE_CMD} -e 's/Linux/${OPSYS}/' ${WRKSRC}/assets/gamecontrollerdb.txt
	@${REINPLACE_CMD} -e 's,/usr/share,${PREFIX}/share,' ${WRKSRC}/UI/NativeApp.cpp
	@${REINPLACE_CMD} -e 's/"unknown"/"${DISTVERSIONFULL}"/' ${WRKSRC}/git-version.cmake
	# additional substitution for bundled ffmpeg
	@${REINPLACE_CMD} -e 's/%%ARCH%%/${ARCH}/' ${WRKSRC}/CMakeLists.txt

	# build bundled ffmpeg
	cd ${WRKSRC}/ffmpeg && \
		${SETENV} ${CONFIGURE_ENV} CC=${CC} CXX=${CXX} ./configure ${FFMPEG_CONFIGURE_ARGS} && \
			${SETENV} ${MAKE_ENV} _COMPILER_ARGS+=features,c11 \
			CPPFLAGS+='-isystem ${LOCALBASE}/include' \
			CFLAGS+='-isystem ${LOCALBASE}/include' \
			CXXFLAGS+='-isystem ${LOCALBASE}/include' \
			LDFLAGS+=-L${LOCALBASE}/lib \
			${GMAKE} -j ${MAKE_JOBS_NUMBER}
	${MKDIR} ${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/lib
	${MKDIR} ${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/include
	${MKDIR} ${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/include/libavcodec
	${MKDIR} ${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/include/libavformat
	${MKDIR} ${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/include/libavutil
	${MKDIR} ${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/include/libswresample
	${MKDIR} ${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/include/libswscale
	for i in `cat ${PATCHDIR}/ffmpeg/ffmpeg-libs`;do \
		${MV} ${WRKSRC}/$${i} \
			${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/lib; \
	done
	for i in `cat ${PATCHDIR}/ffmpeg/ffmpeg-includes`;do \
		${MV} ${WRKSRC}/ffmpeg/$${i} \
			${WRKSRC}/ffmpeg/FreeBSD/${ARCH}/include/$${i}; \
	done

do-install-LIBRETRO-on:
	${MKDIR} ${STAGEDIR}${PREFIX}/${LIBRETRO_PLIST_FILES:H}
	${INSTALL_LIB} ${BUILD_WRKSRC}/lib/${LIBRETRO_PLIST_FILES:T} \
		${STAGEDIR}${PREFIX}/${LIBRETRO_PLIST_FILES:H}
.if ${OPTIONS_SLAVE} == LIBRETRO
.  for d in applications icons man mime ${PORTNAME}
	${RM} -r ${STAGEDIR}${PREFIX}/share/${d}
.  endfor
.endif

do-install-QT5-on do-install-SDL-on:
.if exists(/usr/bin/elfctl)
	${ELFCTL} -e +wxneeded ${STAGEDIR}${PREFIX}/bin/*
.endif
	${MV} ${STAGEDIR}${PREFIX}/bin/${EXENAME} ${STAGEDIR}${PREFIX}/bin/${PORTNAME}
	${INSTALL_MAN} ${_DISTDIR}/${PORTNAME}.1 ${STAGEDIR}${PREFIX}/share/man/man1

.include <bsd.port.mk>
