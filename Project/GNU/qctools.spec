%define qctools_version           0.7.3

Name:           qctools
Version:        %{qctools_version}
Release:        1
Summary:        QCTools

Group:          Applications/Multimedia
License:        BSD-2-Clause
URL:            http://MediaArea.net
Packager:       MediaArea.net SARL <info@mediaarea.net>
Source0:        %{name}_%{version}-1.tar.gz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires:  gcc-c++
BuildRequires:  pkgconfig
BuildRequires:  zlib-devel
%if 0%{?fedora_version} >= 24
BuildRequires: bzip2-devel
%else
%if ! 0%{?mageia}
BuildRequires:  libbz2-devel
%endif
%endif
%if ! 0%{?rhel}
BuildRequires:  yasm
%endif
BuildRequires:  cmake
%if 0%{?suse_version}
BuildRequires:  update-desktop-files
%endif

%if 0%{?suse_version} || 0%{?rhel}
%if 0%{?suse_version} >= 1200
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Widgets)
BuildRequires:  pkgconfig(Qt5Concurrent)
BuildRequires:  pkgconfig(Qt5PrintSupport)
%else
BuildRequires:  libqt4-devel
%endif
%endif

%if 0%{?fedora}
BuildRequires:  pkgconfig(Qt5)
BuildRequires:  desktop-file-utils
%endif

%if 0%{?mageia}
%ifarch x86_64
BuildRequires:  lib64qt5base5-devel
BuildRequires:  lib64bzip2-devel
%else
BuildRequires:  libqt5base5-devel
BuildRequires:  libbzip2-devel
%endif
BuildRequires:  sane-backends-iscan
BuildRequires:  libuuid-devel
%endif

%description
QCTools (Quality Control Tools for Video Preservation)

QCTools (Quality Control Tools for Video Preservation) is a free and open source software tool
that helps users analyze and understand their digitized video files through use of audiovisual analytics and filtering
to help users detect corruptions or compromises in the results of analog video digitization or in born-digital video.
The goal of the project is to cut down the time it takes to perform high-quality video preservation
and direct time towards preservation issues that are solvable - for example, identifying tapes
that would benefit from a second transfer, saving not only the precious time of preservationists
and institutional resources, but giving collections a necessary advantage in the bigger race against time 
to preserve their significant cultural artifacts. QCTools incorporates archival standards and best practices
for reformatting and capturing metadata that enables the long-term preservation of and access to the original artifact,
the digital object, and the associated catalog record.

%prep
%setup -q -n qctools

# build
pushd qctools
	chmod 644 History.txt
	chmod 644 License.html
	./Project/BuildAllFromSource/build
popd

%install
pushd qctools/Project/QtCreator
	install -dm 755 %{buildroot}%{_bindir}
	install -m 755 QCTools %{buildroot}%{_bindir}
popd

# icon
install -dm 755 %{buildroot}%{_datadir}/icons/hicolor/256x256/apps
install -m 644 qctools/Source/Resource/Logo.png %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/%{name}.png
install -dm 755 %{buildroot}%{_datadir}/pixmaps
install -m 644 qctools/Source/Resource/Logo.png %{buildroot}%{_datadir}/pixmaps/%{name}.png

# menu-entry
install -dm 755 %{buildroot}/%{_datadir}/applications
install -m 644 qctools/Project/GNU/GUI/qctools.desktop %{buildroot}/%{_datadir}/applications
%if 0%{?suse_version}
  %suse_update_desktop_file -n qctools AudioVideo AudioVideoEditing
%endif
install -dm 755 %{buildroot}/%{_datadir}/apps/konqueror/servicemenus
install -m 644 qctools/Project/GNU/GUI/qctools.kde3.desktop %{buildroot}/%{_datadir}/apps/konqueror/servicemenus/qctools.desktop
%if 0%{?suse_version}
  %suse_update_desktop_file -n %{buildroot}/%{_datadir}/apps/konqueror/servicemenus/qctools.desktop AudioVideo AudioVideoEditing
%endif
install -dm 755 %{buildroot}/%{_datadir}/kde4/services/ServiceMenus/
install -m 644 qctools/Project/GNU/GUI/qctools.kde4.desktop \
    %{buildroot}/%{_datadir}/kde4/services/ServiceMenus/qctools.desktop
%if 0%{?suse_version}
  %suse_update_desktop_file -n %{buildroot}/%{_datadir}/kde4/services/ServiceMenus/qctools.desktop AudioVideo AudioVideoEditing
%endif


%files
%defattr(-,root,root,-)
%doc qctools/License.html qctools/History.txt
%{_bindir}/QCTools
%{_datadir}/applications/*.desktop
%{_datadir}/pixmaps/*.png
%dir %{_datadir}/icons/hicolor
%dir %{_datadir}/icons/hicolor/256x256
%dir %{_datadir}/icons/hicolor/256x256/apps
%{_datadir}/icons/hicolor/256x256/apps/*.png
%dir %{_datadir}/apps
%dir %{_datadir}/apps/konqueror
%dir %{_datadir}/apps/konqueror/servicemenus
%{_datadir}/apps/konqueror/servicemenus/*.desktop
%dir %{_datadir}/kde4
%dir %{_datadir}/kde4/services
%dir %{_datadir}/kde4/services/ServiceMenus
%{_datadir}/kde4/services/ServiceMenus/*.desktop


%changelog
* Wed Jan 01 2014 MediaArea.net SARL <info@mediaarea.net> - 0.5.0
- See History.txt for more info and real dates
