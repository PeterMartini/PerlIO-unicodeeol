use strict;
use Test::More tests => 16;
use utf8;

BEGIN { use_ok('PerlIO::unicodeeol'); }

binmode STDOUT, "utf8";

# Test without utf-8
{
    open my $FH, "<:raw:unicodeeol", "t/testfile" or die "Couldn't read testfile";
    is <$FH>, "Line 1\n", "Line 1 - matched";
    is <$FH>, "Line 2\n", "Line 2 - matched";
    is <$FH>, "Line 3\n", "Line 3 - matched";
    is <$FH>, "Line 4\xc2\x85Line 5\xc2\x86\n", "Line 4+5 - matched";
    is <$FH>, "Line 6\xe2\x80\xa8Line 7\xe2\x80\xa9Line 8\xe2\x81\n", "Line 6+7+8 - matched";
    is <$FH>, "Line 9\xe2\x80\xaa\n", "Line 9 - matched";
    close $FH;
}

# Test with utf-8
{
    open my $FH, "<:raw:utf8:unicodeeol", "t/testfile" or die "Couldn't read testfile";
    is <$FH>, "Line 1\n", "Line 1 - matched";
    is <$FH>, "Line 2\n", "Line 2 - matched";
    is <$FH>, "Line 3\n", "Line 3 - matched";
    is <$FH>, "Line 4\n", "Line 4 - matched";
    is <$FH>, "Line 5\x{86}\n", "Line 5 - matched";
    is <$FH>, "Line 6\n", "Line 6 - matched";
    is <$FH>, "Line 7\n", "Line 7 - matched";
    {
        my $badstring = <$FH>;
        utf8::encode($badstring);
        is $badstring, "Line 8\xe2\x81\n", "Line 8 - matched";
    }
    is <$FH>, "Line 9\x{202a}\n", "Line 9 - matched";
    close $FH;
}
