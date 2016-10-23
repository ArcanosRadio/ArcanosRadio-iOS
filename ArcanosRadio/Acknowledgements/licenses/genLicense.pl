#!/usr/bin/perl -w

use strict;

my $plistout =  "../Acknowledgements.plist";

system("rm -f $plistout");

open(my $plistfh, '>', $plistout) or die $!;

print $plistfh <<'EOD';
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>StringsTable</key>
    <string>Acknowledgements</string>
    <key>Licenses</key>
    <array>
EOD
for my $i (sort glob("*.license"))
{
    my $value=$i;
    $value =~ s/.license//g;
    print $plistfh <<"EOD";
        <string>$value</string>
EOD
}

print $plistfh <<'EOD';
    </array>
</dict>
</plist>
EOD

close($plistfh);
