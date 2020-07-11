import unittest

include replacetool

const
  templateSpec = """Summary: {{SUMMARY}}
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
{{INSTALL}}

%clean
rm -rf $RPM_BUILD_ROOT

%post

%postun

%files
%defattr(-, root, root)
{{FILES}}

%changelog
"""

suite "generateInstallScript":
  test "normal":
    let path = "/usr/bin/script1"
    let want = @[
      "mkdir -p /usr/bin",
      "cp -p script1 /usr/bin/",
    ]
    check want == generateInstallScript(path)

suite "getInstallFiles":
  test "normal":
    let (inst, files) = getInstallFiles("tests/testpkg")
    check inst == @["mkdir -p /usr/bin", "cp -p script.sh /usr/bin/"]
    check files == @["/usr/bin/script.sh"]

suite "replaceTemplate":
  test "normal":
    let got = replaceTemplate(
      templateSpec,
      package = "test",
      maintainer = "author",
      version = "1.0.0",
      arch = "test",
      desc = "description",
      install = "mkdir -p /usr/bin\ncp -p test1 /usr/bin/\nmkdir -p /usr/bin\ncp -p test2 /usr/bin/",
      files = "/usr/bin/test1\n/usr/bin/test2",
      license = "MIT",
      )
    const want = """Summary: {{SUMMARY}}
Name: test
Version: 1.0.0
Release: 1%{?dist}
Group: Applications
License: MIT
Packager: {{PACKAGER}}
Vendor: author

Source: tmp.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-buildroot

%description
description

%prep
rm -rf $RPM_BUILD_ROOT

%setup -n %{name}

%build

%install
mkdir -p /usr/bin
cp -p test1 /usr/bin/
mkdir -p /usr/bin
cp -p test2 /usr/bin/

%clean
rm -rf $RPM_BUILD_ROOT

%post

%postun

%files
%defattr(-, root, root)
/usr/bin/test1
/usr/bin/test2

%changelog
"""
    check want == got

