import unittest

include replacetool

suite "generateInstallScript":
  test "normal":
    let path = "/usr/bin/script1"
    let want = @[
      "mkdir -p /usr/bin/",
      "cp -p script1 /usr/bin/",
    ]
    check want == generateInstallScript(path)

