#!/usr/bin/perl -w

# Original article and script:
# http://stackoverflow.com/questions/6428353/best-way-to-add-license-section-to-ios-settings-bundle

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
    <dict>
EOD
for my $i (sort glob("*.license"))
{
    my $key=$i;
    my $content=`cat $i`;
    $content =~ s/^\s+|\s+$//g;
    $key =~ s/.license//g;
    print $plistfh <<"EOD";
        <key>$key</key>
        <string>$content</string>
EOD
}

print $plistfh <<'EOD';
    </dict>
</dict>
</plist>
EOD

close($plistfh);