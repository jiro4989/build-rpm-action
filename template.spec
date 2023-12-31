Summary: {{SUMMARY}}
Name: {{PACKAGE}}
Version: {{VERSION}}
Release: 1%{?dist}
Group: Applications
License: {{LICENSE}}
Packager: {{MAINTAINER}}
Vendor: {{VENDOR}}

Source: tmp.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-buildroot
BuildArch: {{ARCH}}
{{BUILD_REQUIRES}}
{{REQUIRES}}

%description
{{DESC}}

%prep
rm -rf $RPM_BUILD_ROOT

%setup -n %{name}

%build

%install
{{INSTALL}}

%clean
rm -rf $RPM_BUILD_ROOT

%post
{{POST}}

%postun

%files
%defattr(-, root, root)
{{FILES}}

%changelog
