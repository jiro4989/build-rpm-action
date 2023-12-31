import unittest

include replacetool

const
  templateSpec = """Summary: {{SUMMARY}}
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
"""

suite "generateInstallScript":
  test "normal":
    let path = "/usr/bin/script1"
    let want = @[
      "mkdir -p %{buildroot}/usr/bin",
      "cp -p usr/bin/script1 %{buildroot}/usr/bin/",
    ]
    check want == generateInstallScript(path)

suite "getInstallFiles":
  test "normal":
    let (inst, files) = getInstallFiles("tests/testpkg")
    check inst == @["mkdir -p %{buildroot}/usr/bin", "cp -p usr/bin/script.sh %{buildroot}/usr/bin/"]
    check files == @["/usr/bin/script.sh"]

suite "replaceTemplate":
  test "normal":
    let got = replaceTemplate(
      templateSpec,
      summary = "package summary",
      package = "test",
      maintainer = "author",
      version = "1.0.0",
      arch = "noarch",
      desc = "description",
      install = "mkdir -p /usr/bin\ncp -p test1 /usr/bin/\nmkdir -p /usr/bin\ncp -p test2 /usr/bin/",
      files = "/usr/bin/test1\n/usr/bin/test2",
      license = "MIT",
      vendor = "author.org",
      post = "echo 1;\necho 2",
      buildRequires = "BuildRequires: perl-Git = 2.43.0",
      requires = "Requires: git-core = 2.43.0",
      )
    const want = """Summary: package summary
Name: test
Version: 1.0.0
Release: 1%{?dist}
Group: Applications
License: MIT
Packager: author
Vendor: author.org

Source: tmp.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-buildroot
BuildArch: noarch
BuildRequires: perl-Git = 2.43.0
Requires: git-core = 2.43.0

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
echo 1;
echo 2

%postun

%files
%defattr(-, root, root)
/usr/bin/test1
/usr/bin/test2

%changelog
"""
    check want == got

  test "empty requires":
    let got = replaceTemplate(
      templateSpec,
      summary = "package summary",
      package = "test",
      maintainer = "author",
      version = "1.0.0",
      arch = "noarch",
      desc = "description",
      install = "mkdir -p /usr/bin\ncp -p test1 /usr/bin/\nmkdir -p /usr/bin\ncp -p test2 /usr/bin/",
      files = "/usr/bin/test1\n/usr/bin/test2",
      license = "MIT",
      vendor = "author.org",
      post = "echo 1;\necho 2",
      buildRequires = "",
      requires = "",
      )
    const want = """Summary: package summary
Name: test
Version: 1.0.0
Release: 1%{?dist}
Group: Applications
License: MIT
Packager: author
Vendor: author.org

Source: tmp.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-buildroot
BuildArch: noarch



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
echo 1;
echo 2

%postun

%files
%defattr(-, root, root)
/usr/bin/test1
/usr/bin/test2

%changelog
"""
    check want == got

