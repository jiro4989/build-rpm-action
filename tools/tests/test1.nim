import unittest

include replacetool

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

