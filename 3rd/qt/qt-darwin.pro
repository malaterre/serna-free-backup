
PACKAGE_CONFIGURE   = ./configure
PACKAGE_MAKE        = make
PACKAGE_MAKEFILE    = Makefile
PACKAGE_MAKEFILEOPT = -f
PACKAGE_MAKEOPTS    = -j2
PACKAGE_CLEANOPTS   = clean

PACKAGE_CFG_OPTIONS     += \
                           -no-framework \
                           -no-sql-odbc \
                           -universal
