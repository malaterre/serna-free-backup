#!
#! Template for pyqt as a Syntext 3rd component
#!
#!
#!##############################################################################
#${
    IncludeTemplate("3rd/pkg-utils");
    IncludeTemplate("pkg-info");

    my $third_dir = Project("THIRD_DIR");
    my %package = ( NAME => 'pyqt' );
    my $sip_dir = get_package_info('sip', 'SIP_DIR');
    if ($sip_dir && -d $sip_dir) {
        $package{'PYQT_DIR'} = "$sip_dir/PyQt4";
    }
    if (Config("syspkg") || Config("syspkgonly")) {
        my @pathlist = split($is_unix ? ':' : ';', $ENV{'PATH'});
        my ($pyuic4) = find_file_in_path('pyuic4', @pathlist);
        if (!$pyuic4) {
            tmake_error("Can't find pyqt package") if Config("syspkgonly");
        }
        else {
            $package{'PYUIC'} = $pyuic4;
            ($package{'PYRCC'}) = find_file_in_path('pyrcc4', @pathlist);
            ($package{'PYLUPDATE'}) = find_file_in_path('pylupdate4',
                                                        @pathlist);
            my $sf_cmd = <<"EOF";
import sys
sys.path.insert(0, '$third_dir/sip')
from PyQt4 import pyqtconfig
print pyqtconfig._pkg_config['pyqt_sip_flags']
EOF

            my $sip_flags = `python -c "$sf_cmd"`;
            $package{'PYQT_SIP_FLAGS'} = $sip_flags;

            write_package("$third_dir/lib/pyqt.pkg", \%package);
            write_file("$third_dir/pyqt/MANIFEST", '');
            Project("TMAKE_TEMPLATE=");
            return;
        }
    }
    
    foreach (qw/pyrcc4 pyuic4 pylupdate4/) {
        $package{uc($_)} = normpath("$third_dir/bin/$_");
    }
    write_package("$third_dir/lib/pyqt.pkg", \%package);

    IncludeTemplate("$third_dir/qt/qtdir.t");
    my $qtdir = Project("QT_BUILDDIR");

    Project("PACKAGE_CFG_ENV += QTDIR=$qtdir", "PACKAGE_MAKE_ENV += QTDIR", "QTDIR=$qtdir");
    Project("PACKAGE_CFG_ENV += PATH=%PATH%;%QTDIR%\\bin") unless ($is_unix);
    Project("PACKAGE_MAKE_ENV_ADD += PATH=%QTDIR%\\bin;%PATH%;") unless ($is_unix);
    Project('darwin:PACKAGE_CFG_ENV += DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${QTDIR}/lib');
    Project('PACKAGE_CFG_ENV += PYTHON_EXE='.expand_path(Project('PYTHON')));

    if (open(QTCONFIG, ">qtconfig.txt")) {
        print QTCONFIG "$qtdir\n";
        print QTCONFIG "$qtdir${dir_sep}include\n";
        print QTCONFIG "$qtdir${dir_sep}lib\n";
        print QTCONFIG "$qtdir${dir_sep}bin\n";
        print QTCONFIG "$qtdir\n$qtdir${dir_sep}plugins\n";
        print QTCONFIG "PyQt_SessionManager\n";
        print QTCONFIG "PyQt_Accessibility\n" if ("darwin" eq $pf);
        close(QTCONFIG);
    }
#$}
QTDIR = #$ Expand("QTDIR");
