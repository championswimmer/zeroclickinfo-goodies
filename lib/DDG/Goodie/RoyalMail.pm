package DDG::Goodie::RoyalMail;

use DDG::Goodie;

zci is_cached   => 1;
zci answer_type => "royal_mail";

primary_example_queries 'royal mail RU401513974GB';
secondary_example_queries 'track parcelforce PBTM8237263001';
description 'Track a Royal Mail / Parcelforce parcel';
icon_url "/i/www.royalmail.com.ico";
name 'Royal Mail';
code_url
    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RoyalMail.pm';
category 'ids';
topics 'special_interest';
attribution
    github  => [ 'https://github.com/TopHattedCoder', 'Tom Bebbington' ],
    twitter => [ 'http://twitter.com/TopHattedCoder', 'TopHattedCoder' ];

# Regex for royal mail.
my $rm_qr = qr/royalmail|parcelforce/io;

my $tracking_qr = qr/package|parcel|track(?:ing|)|num(?:ber|)|\#/i;

# note: parcelforce format listed at http://www.parcelforce.com/help-information/frequently-asked-questions/track-parcel#2
my $parcel
    = qr/[A-Z]{2}[0-9]{7}|[A-Z]{4}[0-9]{10}|[A-Z]{2}[0-9]{9}GB|[0-9]{12}|[A-Z]{2}[0-9]{9}[A-Z]{2}/i;
triggers query_nowhitespace_nodash => qr/
                                        ^$rm_qr.*?(?<parcel_number>$parcel)$|
                                        ^(?<parcel_number>$parcel).*?$rm_qr$|
                                        ^(?:$tracking_qr|$rm_qr|)*(?<parcel_number>$parcel)(?:$tracking_qr|$rm_qr|)*$
                                        /xo;

handle query_nowhitespace_nodash => sub {
    my $parcel_number = $+{parcel_number};
    return $parcel_number,
        heading => 'Royal Mail / Parcelforce Tracking',
        html =>
        qq(Track this parcel at <a href="http://www.royalmail.com/portal/rm/track?trackNumber=$parcel_number">Royal Mail</a> or <a href="http://www.parcelforce.com/track-trace?trackNumber=$parcel_number">Parcelforce</a>.);
};

1;
