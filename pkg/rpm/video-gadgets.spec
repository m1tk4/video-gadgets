%define __spec_install_post %{nil}
%define debug_package %{nil}
%define __os_install_post %{_dbpath}/brp-compress
%define _builddir ./
%define _sourcedir ./
%define _rpmdir ./
%define _build_name_fmt dist/%%{NAME}-%%{VERSION}.%%{ARCH}.rpm
%{!?build_version: %define build_version 0.0.0}

Summary: Collection of video tools
Name: video-gadgets
Version: %{build_version}
Release: latest
License: MIT
Group: Development/Tools
URL: https://github.com/m1tk4/video-gadgets

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch

Requires: dejavu-sans-mono-fonts ffmpeg

%description
%{summary}

%prep
# nothing to prep

%build
# nothing to build

%install
rm -rf %{buildroot}
install --mode=644 -D _video-gadgets-common.sh      %{buildroot}%{_bindir}/_video-gadgets-common.sh
install --mode=755 -D hdbars                        %{buildroot}%{_bindir}/hdbars
install --mode=755 -D gif_encode                    %{buildroot}%{_bindir}/gif_encode
install --mode=755 -D enc_profile                   %{buildroot}%{_bindir}/enc_profile
install --mode=644 -D enc_profile.conf              %{buildroot}%{_sysconfdir}/enc_profile.conf

%clean
# Make a tarball copy before cleanup
here=`pwd`
pushd %{buildroot}
tar cvzf $here/dist/video-gadgets-%{build_version}.tgz `find -type f`
popd
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_bindir}/*
%config(noreplace)%{_sysconfdir}/enc_profile.conf

%changelog
* Sat Feb 12 2022 Dimitri Tarassenko <mitka@mitka.us> 1.0-1
- First Build
