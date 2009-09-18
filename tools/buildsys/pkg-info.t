#${
    return if Project("PKG_INFO_T_INCLUDED");
    Project("PKG_INFO_T_INCLUDED = 1");
    %packages = ();

    sub read_pkginfo_file {
        my ($path) = @_;
        my $pkgdict = ScanProjectRaw($path);
        my $name = $path;
        $name =~ s^.*/^^;
        $name =~ s^\.pkg$^^;
        $pkgdict->{'NAME'} = $name;
        return $pkgdict;
    }

    sub dump_pkginfo {
        my ($name) = @_;
        return unless defined %packages and defined $packages{$name};
        my $pkginfo = $packages{$name};
        print STDERR "PACKAGE: $name\n";
        foreach (keys %{$pkginfo}) {
            print STDERR "\t$_: $pkginfo->{$_}\n";
        }
    }


    sub read_packages {
        my $infopath = Project("PKGINFOPATH");
        $infopath = normpath(expand_path($infopath));
        my @pkgfiles = glob("$infopath/*.pkg");
        foreach (@pkgfiles) {
            my $pkginfo = read_pkginfo_file($_);
            my $name = $pkginfo->{'NAME'};
            $packages{$name} = $pkginfo;
        }
    }

    sub get_package_info {
        my ($pkgname, $key) = @_;
        if (defined $packages{$pkgname}) {
            my $pkginfo = $packages{$pkgname};
            return $pkginfo->{$key} if defined $pkginfo->{$key};
        }
        return '';
    }

    sub process_components
    {
        my ($pkginfo) = shift;
        my @components = qw/CFLAGS INCLUDES LIBS LFLAGS/;
        @components = @_ if (@_ and @_[0]);
        foreach (@components) {
            if ('CFLAGS' eq $_) {
                foreach (split /\s+/, $pkginfo->{'CFLAGS'}) {
                    Project("TMAKE_CFLAGS *= $_", "TMAKE_CXXFLAGS *= $_");
                }
            }
            elsif ('INCLUDES' eq $_) {
                foreach (split /\s+/, $pkginfo->{'INCLUDES'}) {
                    Project("INCLUDEPATH *= ;$_;");
                }
            }
            elsif ('LIBS' eq $_) {
                foreach (split /\s+/, $pkginfo->{'LIBS'}) {
                    Project("LIBS *= $_");
                }
            }
            elsif ('LFLAGS' eq $_) {
                foreach (split /\s+/, $pkginfo->{'LFLAGS'}) {
                    Project("TMAKE_LFLAGS *= $_");
                }
            }
        }
    }

    read_packages();

    foreach (split /\s+/, Project("USE")) {
        my ($name, $component) = split(/\./, $_, 2);
        my $pkginfo = $packages{$name};
        unless ($pkginfo) {
            tmake_warning("Reference to unknown package '$_'\n");
            next;
        }
        process_components($pkginfo, $component);
    }
#$}
