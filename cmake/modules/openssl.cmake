#
# OpenSSL
#
option(USE_BUNDLED_OPENSSL "Enable building of the bundled OpenSSL" ${USE_BUNDLED_DEPS})

if(OPENSSL_INCLUDE_DIR)
	# we already have openssl
elseif(NOT USE_BUNDLED_OPENSSL)
	find_package(OpenSSL REQUIRED)
	message(STATUS "Found OpenSSL: include: ${OPENSSL_INCLUDE_DIR}, lib: ${OPENSSL_LIBRARIES}")
else()
	set(OPENSSL_BUNDLE_DIR "${PROJECT_BINARY_DIR}/openssl-prefix/src/openssl")
	set(OPENSSL_INSTALL_DIR "${OPENSSL_BUNDLE_DIR}/target")
	set(OPENSSL_INCLUDE_DIR "${PROJECT_BINARY_DIR}/openssl-prefix/src/openssl/include")
	set(OPENSSL_LIBRARY_SSL "${OPENSSL_INSTALL_DIR}/lib/libssl.a")
	set(OPENSSL_LIBRARY_CRYPTO "${OPENSSL_INSTALL_DIR}/lib/libcrypto.a")

	if(NOT TARGET openssl)
		message(STATUS "Using bundled openssl in '${OPENSSL_BUNDLE_DIR}'")

		ExternalProject_Add(openssl
			PREFIX "${PROJECT_BINARY_DIR}/openssl-prefix"
			URL "https://github.com/openssl/openssl/archive/OpenSSL_1_1_1k.tar.gz"
			URL_HASH "SHA256=b92f9d3d12043c02860e5e602e50a73ed21a69947bcc74d391f41148e9f6aa95"
			CONFIGURE_COMMAND ./config no-shared --prefix=${OPENSSL_INSTALL_DIR}
			BUILD_COMMAND ${CMD_MAKE}
			BUILD_IN_SOURCE 1
			BUILD_BYPRODUCTS ${OPENSSL_LIBRARY_SSL} ${OPENSSL_LIBRARY_CRYPTO}
			INSTALL_COMMAND ${CMD_MAKE} install)
	endif()
endif()

include_directories("${OPENSSL_INCLUDE_DIR}")
