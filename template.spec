Summary: {{SUMMARY}}
Name: {{PACKAGE}}
Version: {{VERSION}}
Release: 1%{?dist}
Group: Applications
License: {{LICENSE}}
Packager: {{PACKAGER}}
Vendor: {{MAINTAINER}}

Source: tmp.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-buildroot

%description
{{DESC}}

%prep
rm -rf $RPM_BUILD_ROOT

%setup -n %{name}

%build

%install
find .
{{INSTALL}}

%clean
rm -rf $RPM_BUILD_ROOT

%post

%postun

%files
%defattr(-, root, root)
{{FILES}}

%changelog
